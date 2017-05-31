//
//  BatteryLevelNotifier.swift
//  META
//
//  Created by Pascal Schönthier on 31.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices


class BatterieLevelNotifier {
    
    var observer: Observable!
    
    private var energyTimer: Timer!
    private var energyConsumptions = [BatterieLevel]() {
        willSet(newValue) {
            observer.willChange(propertyName: "energyConsumptions", newPropertyValue: newValue)
        }
        
        didSet {
            observer.didChange(propertyName: "energyConsumptions", oldPropertyValue: oldValue)
        }
    }
    
    var currentEnegyConsumption: EnergyConsumtion? {
        get {
            let size = energyConsumptions.count
            let latest = energyConsumptions[size-1..<size]
            
            let sum = latest.reduce(0.0) { $0 + $1.value }
            let sub = latest.reduce(0.0) { $0 - $1.value }
            
            return (sub / (sum/2)) * 100
        }
    }
    
    init() {
        observer = DefaultObserver()
        setupEnegryTimer()
    }
    
    private func setupEnegryTimer() {
        energyTimer = Timer.schedule(repeatInterval: Constants.energyTimerInterval) { _ in
            self.energyConsumptions.append(self.createBatterieLevelEntry())
        }
    }
    
    private func createBatterieLevelEntry() -> BatterieLevel {
        return BatterieLevel(value: SystemServices().batteryLevel,
                             timestamp: Date().timeIntervalSince1970)
    }
    
    deinit {
        energyTimer.invalidate()
    }
    
}
