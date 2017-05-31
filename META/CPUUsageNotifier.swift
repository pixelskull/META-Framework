//
//  CPUUsageNotifier.swift
//  META
//
//  Created by Pascal Schönthier on 31.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices

class CPUUsageNotifier {
    
    let observer: Observable!
    
    var cpuTimer: Timer!
    var cpuUsages = [CpuUsage]() {
        willSet {
            observer.willChange(propertyName: "cpuUsages", newPropertyValue: newValue)
        }
        
        didSet {
            observer.didChange(propertyName: "cpuUsages", oldPropertyValue: oldValue)
        }
    }
    
    
    var currentCpuUsage: CpuUsage? {
        get { return cpuUsages.last }
    }
    
    init() {
        observer = DefaultObserver()
        setupCpuTimer()
    }
    
    private func setupCpuTimer() {
        cpuTimer = Timer.schedule(repeatInterval: Constants.cpuTimerInterval) { _ in
            self.cpuUsages.append(self.createCpuUsageEntry())
        }
    }
    
    private func createCpuUsageEntry() -> CpuUsage {
        return CpuUsage(value: SystemServices().cpuUsage,
                        timestamp: Date().timeIntervalSince1970)
    }
    
    deinit {
        cpuTimer.invalidate()
    }
}
