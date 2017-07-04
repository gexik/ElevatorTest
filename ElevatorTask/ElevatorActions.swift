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
    
    var currentStopFloor: Int = 0       // Текущий этаж (стоит)
    var currentDrivableFloor: Int = 0   // Текущий этаж (едет)
    var floorsCountToStopFloor: Int = 0 // Кол-во этажей до остановки
    var timeToStopFloor: Int = 0        // Время между этажами
    var timeToNextStop: Int = 0         // Время до прибытия
    
    var timer: Timer!
    
    var actionString: String!
    
    internal typealias callback = (_ actionString : String)->()
    
     func callElevator(side: CallSide, speed: Int, floorNumber: Int, timeOpenDoors: Int, timeCloseDoors: Int, floosCount: Int, floorHeight: Int, completion : @escaping callback) {
        elevator = ElevatorModel(speed: speed, floorNumber: floorNumber, timeForOpenDoors: TimeInterval(timeOpenDoors), timeForCloseDoors: TimeInterval(timeCloseDoors))
        building = BuildingModel(floosCount: floosCount, floorHeight: floorHeight)
        
        currentStopFloor = elevator.currentFloor
        currentDrivableFloor = currentStopFloor
        
        floorsCountToStopFloor = abs(self.elevator.currentFloor - self.elevator.nextFloor)
        timeToStopFloor = (self.building.floorHeight / self.elevator.speed)
        timeToNextStop = floorsCountToStopFloor * timeToStopFloor
        
        runTimedWhenElevftorStand()
    }
    
    @objc fileprivate func runTimedWhenElevftorMoving() {
        
//        floorsCountToStopFloor = abs(elevator.currentFloor - elevator.nextFloor)
//        timeToStopFloor = floorsCountToStopFloor * (building.floorHeight / elevator.speed)
        
        print(floorsCountToStopFloor)
        print(timeToStopFloor)
        
        floorsCountToStopFloor -= 1
        currentDrivableFloor += 1
        
        if (floorsCountToStopFloor == 0) {
            invalidateTimer()
        } else {
            let message = String(format: "Этаж %d", currentDrivableFloor)
            postMessage(message: message)
            //do my stuff here...
            
        }
        
    }
    
    fileprivate func runTimedWhenElevftorStand() {
        
        timer = Timer.scheduledTimer(withTimeInterval:elevator.timeForOpenDoors, repeats: false, block: { (t) in
            self.invalidateTimer()
            
            self.postMessage(message: "Двери открыты")
            
            self.timer = Timer.scheduledTimer(withTimeInterval:self.elevator.timeForCloseDoors, repeats: false, block: { (t) in
                self.invalidateTimer()
                
                self.postMessage(message: "Двери закрыты")
                
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timeToStopFloor), target: self, selector: #selector(self.runTimedWhenElevftorMoving), userInfo: nil, repeats: true)
            })
        })
        
//        if elevator.nextFloor == currentStopFloor {
//            timer = Timer.scheduledTimer(withTimeInterval:elevator.timeForOpenDoors, repeats: false, block: { (t) in
//                self.invalidateTimer()
//                
//                self.postMessage(message: "Двери открыты")
//                
//                self.timer = Timer.scheduledTimer(withTimeInterval:self.elevator.timeForCloseDoors, repeats: false, block: { (t) in
//                    self.invalidateTimer()
//
//                    self.postMessage(message: "Двери закрыты")
//
//                    self.timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.runTimedWhenElevftorMoving), userInfo: nil, repeats: true)
//                })
//            })
//        } else {
//            timer = Timer.scheduledTimer(withTimeInterval:0, repeats: false, block: { (t) in
//                self.invalidateTimer()
//              //  completion("".uppercased())
//            })
//        }
    }
    
    fileprivate func postMessage(message: String) {
        print(message.uppercased())
    }
    
    fileprivate func invalidateTimer() {
        if (timer != nil) {
            timer.invalidate()
        }
    }
}

//
