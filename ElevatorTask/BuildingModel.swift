//
//  BuildingModel.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import Foundation

struct BuildingModel {
    var floosCount: Float = 5
    var floorHeight: Float
    
    init(floosCount: Float, floorHeight: Float) {
        self.floosCount = floosCount
        self.floorHeight = floorHeight
    }
}
