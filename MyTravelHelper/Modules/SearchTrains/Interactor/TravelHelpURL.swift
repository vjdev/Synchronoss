//
//  TravelHelpURL.swift
//  MyTravelHelper
//
//  Created by Vijeesh on 09/01/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

public struct TravelHelpURL {
    static let baseURL = "http://api.irishrail.ie/realtime/realtime.asmx/"
    static let getAllStations = "\(baseURL)getAllSttionsXML"
    static let getStationDataByCode = "\(baseURL)getStationDataByCodeXML?StationCode="
    static let getTrainMovement = "\(baseURL)getTrainMovementsXML?"
}
