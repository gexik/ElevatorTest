//
//  BuildingModel.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import Foundation

struct BuildingModel {
    var floosCount: Int = 5
    var floorHeight: Int
    
    init(floosCount: Int, floorHeight: Int) {
        self.floosCount = floosCount
        self.floorHeight = floorHeight
    }
}
