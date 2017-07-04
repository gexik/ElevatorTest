//
//  ElevatorActions.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 04.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import Foundation

enum CallSide {
    case inSide
    case outSide
}

class ElevatorActions: NSObject {
    static let shared = ElevatorActions()
    
    var elevator: ElevatorModel!
    var building: BuildingModel!
    
    var currentStopFloor: Float = 0       // Текущий этаж (стоит)
    var currentDrivableFloor: Float = 0   // Текущий этаж (едет)
    var floorsCountToStopFloor: Float = 0 // Кол-во этажей до остановки
    var timeToStopFloor: Float = 0        // Время между этажами - неизм
    var timeToNextStop: Float = 0         // Время до прибытия
    
    var timer: Timer!
    
    var actionString: String!
    
    internal typealias callback = (_ actionString : String)->()
    
     func callElevator(side: CallSide, speed: Float, floorNumber: Float, timeOpenDoors: Float, timeCloseDoors: Float, floosCount: Float, floorHeight: Float, completion : @escaping callback) {
        elevator = ElevatorModel(speed: speed, floorNumber: floorNumber, timeForOpenDoors: TimeInterval(timeOpenDoors), timeForCloseDoors: TimeInterval(timeCloseDoors))
        building = BuildingModel(floosCount: floosCount, floorHeight: floorHeight)
                
        floorsCountToStopFloor = abs(currentStopFloor - elevator.nextFloor)
        timeToStopFloor = (self.building.floorHeight / elevator.speed)
        timeToNextStop = floorsCountToStopFloor * timeToStopFloor

        runTimedWhenElevftorStand()
    }

    @objc fileprivate func runTimedWhenElevftorMoving() {
        floorsCountToStopFloor -= 1
        
        if currentStopFloor <  elevator.nextFloor {
            currentDrivableFloor += 1
        } else {
            currentDrivableFloor -= 1
        }
        
        if (floorsCountToStopFloor == 0) {
            currentStopFloor = currentDrivableFloor
            invalidateTimer()
            runTimedWhenElevftorStand()
        }
        
        postMessage(message: String(format: "Этаж %.f", currentDrivableFloor))
    }
    
    fileprivate func runTimedWhenElevftorStand() {
        if elevator.nextFloor == currentStopFloor {
            timer = Timer.scheduledTimer(withTimeInterval:elevator.timeForOpenDoors, repeats: false, block: { (t) in
                self.invalidateTimer()
                
                self.openDoors()
                
                self.timer = Timer.scheduledTimer(withTimeInterval:self.elevator.timeForCloseDoors, repeats: false, block: { (t) in
                    self.invalidateTimer()
                    self.closeDoors()
                })
            })
        } else if elevator.currentFloor == currentStopFloor  {
            timer = Timer.scheduledTimer(withTimeInterval:elevator.timeForOpenDoors, repeats: false, block: { (t) in
                self.invalidateTimer()
                
                self.openDoors()
                
                self.timer = Timer.scheduledTimer(withTimeInterval:self.elevator.timeForCloseDoors, repeats: false, block: { (t) in
                    self.invalidateTimer()
                    self.closeDoors()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timeToStopFloor), target: self, selector: #selector(self.runTimedWhenElevftorMoving), userInfo: nil, repeats: true)
                })
            })
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timeToStopFloor), target: self, selector: #selector(self.runTimedWhenElevftorMoving), userInfo: nil, repeats: true)
        }
    }
    
    @objc fileprivate func openDoors() {
        self.postMessage(message: "Двери открыты")
    }
    
    @objc fileprivate func closeDoors() {
        self.postMessage(message: "Двери закрыты")
    }
    
    fileprivate func postMessage(message: String) {
        
        let concatenatedString = String(format: "%@ | текущий этаж (%.f)", message, currentDrivableFloor)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReciveNotification"), object: concatenatedString)
    }
    
    fileprivate func invalidateTimer() {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }
}

//
