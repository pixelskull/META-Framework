//
//  BatteryInfoService.swift
//  META
//
//  Created by Pascal Schönthier on 06.04.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import UIKit

class BatteryInfoService {
    
    class func batteryLevel() -> Double {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        let chargingState: Float    = device.batteryLevel
        
        guard chargingState > 0.0 else { return -1 }
        let batteryLevel = chargingState * 100
        return Double(batteryLevel)
    }
    
    class func isCharging() -> Bool {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        switch device.batteryState {
        case .charging, .full:
            return true
        default:
            return false
        }
    }
    
    class func isFullyCharged() -> Bool {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        switch device.batteryState {
        case .full:
            return true
        default:
            return false
        }
    }
    
}
