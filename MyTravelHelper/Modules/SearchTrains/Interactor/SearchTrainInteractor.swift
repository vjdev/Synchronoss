//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        if Reach().isNetworkReachable() {
            let url =  TravelHelpURL.getAllStations
            APIHandler.sharedInstane.request(url: url) { data, error in
                guard let data = data, error == nil else {
                    self.presenter?.showAPIErrorMessage(error: error?.localizedDescription ?? "")
                    return
                }
                if let station = try? XMLDecoder().decode(Stations.self, from: data) {
                    self.presenter!.stationListFetched(list: station.stationsList)
                }
            }
            
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        let urlString = "\(TravelHelpURL.getStationDataByCode)\(sourceCode)"
        if Reach().isNetworkReachable() {
            APIHandler.sharedInstane.request(url: urlString) { data, error in
                guard let data = data, error == nil else {
                    self.presenter?.showAPIErrorMessage(error: error?.localizedDescription ?? "")
                    return
                }
                let stationData = try? XMLDecoder().decode(StationData.self, from: data)
                if let _trainsList = stationData?.trainsList {
                    self.proceesTrainListforDestinationCheck(trainsList: _trainsList)
                } else {
                    self.presenter!.showNoTrainAvailbilityFromSource()
                }
            }
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        let today = Date()
        let group = DispatchGroup()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: today)
        
        for index  in 0...trainsList.count-1 {
            group.enter()
            let urlString = "\(TravelHelpURL.getTrainMovement)TrainId=\(trainsList[index].trainCode)&TrainDate=\(dateString)"
            if Reach().isNetworkReachable() {
                APIHandler.sharedInstane.request(url: urlString) { data, error in
                    guard let data = data, error == nil else {
                        self.presenter?.showAPIErrorMessage(error: error?.localizedDescription ?? "")
                        return
                    }
                    let trainMovements = try? XMLDecoder().decode(TrainMovementsData.self, from: data)

                    if let _movements = trainMovements?.trainMovements {
                        let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                        let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                        let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                        let isDestinationAvailable = desiredStationMoment.count == 1

                        if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                            _trainsList[index].destinationDetails = desiredStationMoment.first
                        }
                    }
                    group.leave()
                }
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}
