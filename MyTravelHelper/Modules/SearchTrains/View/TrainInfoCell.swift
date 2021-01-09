//
//  TrainInfoCell.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class TrainInfoCell: UITableViewCell {
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var sourceTimeLabel: UILabel!
    @IBOutlet weak var destinationInfoLabel: UILabel!
    @IBOutlet weak var souceInfoLabel: UILabel!
    @IBOutlet weak var trainCode: UILabel!
    
    func setupCell(train: StationTrain) {
        trainCode.text = train.trainCode
        souceInfoLabel.text = train.stationFullName
        sourceTimeLabel.text = train.expDeparture
        if let destinationDetails = train.destinationDetails {
            destinationInfoLabel.text = destinationDetails.locationFullName
            destinationTimeLabel.text = destinationDetails.expDeparture
        }
    }
}
