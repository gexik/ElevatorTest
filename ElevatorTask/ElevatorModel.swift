//
//  ElevatorModel.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import Foundation

struct ElevatorModel {
    var speed: Int
    var timeWaitingDoors: TimeInterval
    
    init(speed: Int, timeWaitingDoors: TimeInterval) {
        self.speed = speed
        self.timeWaitingDoors = timeWaitingDoors
        

    }
}


//Time between opening and closing doors
