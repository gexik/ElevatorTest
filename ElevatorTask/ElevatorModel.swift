//
//  ElevatorModel.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import Foundation

struct ElevatorModel {
    var speed: Float
    var timeForOpenDoors: TimeInterval
    var timeForCloseDoors: TimeInterval
    var currentFloor: Float = 0
    var nextFloor: Float = 0
    
    init(speed: Float, floorNumber: Float, timeForOpenDoors: TimeInterval, timeForCloseDoors: TimeInterval) {
        self.speed = speed
        self.nextFloor = floorNumber
        self.timeForOpenDoors = timeForOpenDoors
        self.timeForCloseDoors = timeForCloseDoors
    }
}
