//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
    
    override func setUp() {
      presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }

    func testfetchallStations() {
        presenter.fetchallStations()

        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
    }
    
    func testFetchTrainsFromSource() {
        presenter.searchTapped(source: "lburn", destination: "newry")
        XCTAssertTrue(view.isShowNoTrainAvailbilityFromSourceCalled)
    }
    
    func testNoInternetAvailability() {
        XCTAssertTrue(Reach().isNetworkReachable())
    }

    func testInvalidSourceDestination() {
        presenter.searchTapped(source: "lbffurn", destination: "newffry")
        XCTAssertTrue(view.invalidSourceOrDestinationAlert)
    }
    
    func testAPIErrorReceived() {
        
    }
    
    override func tearDown() {
        presenter = nil
    }
}


class SearchTrainMockView:PresenterToViewProtocol {

    var isSaveFetchedStatinsCalled = false
    var isShowNoTrainAvailbilityFromSourceCalled = false
    var isInternetNotAvailable = false
    var invalidSourceOrDestinationAlert = false
    
    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {
        invalidSourceOrDestinationAlert = true
    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {

    }
    
    func showNoTrainsFoundAlert() {
        
    }
    
    func showNoTrainAvailbilityFromSource() {
        isShowNoTrainAvailbilityFromSourceCalled = true
    }
    
    func showNoInterNetAvailabilityMessage() {
        isInternetNotAvailable = true
    }
    
    func showAPIErrorMessage(message: String) {
        
    }
}

class SearchTrainInteractorMock:PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        let station = StationTrain(trainCode: "124", fullName: "Banf", stationCode: "12", trainDate: "12 Dec", dueIn: 6, lateBy: 4, expArrival: "now", expDeparture: "later")
        presenter?.fetchedTrainsList(trainsList: [station])
    }
    
    func fetchallStations() {
        let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        presenter?.stationListFetched(list: [station])
    }

}
