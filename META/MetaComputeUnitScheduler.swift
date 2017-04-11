//
//  MetaComputeUnitScheduler.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices

typealias Latency = Double
typealias EnergyConsumtion = Double
typealias CpuUsage = Float

protocol MetaComputeUnitSchedulable {
    
    var computeUnit: MetaComputeUnit { get set } // TODO: make this const
    
    var backendUrl: URL? { get set }
    
    var currentLatency: Latency { get set }
    var currentEnegyConsumption: EnergyConsumtion { get set }
    
    init(unit: MetaComputeUnit)
    
    func start()
    func start(action: (Any) -> Any)
}

class MetaComputeScheduler: MetaComputeUnitSchedulable {
    
    var currentLatency: Latency
    var currentEnegyConsumption: EnergyConsumtion
    var currentCpuUsage: CpuUsage
    
    var backendUrl: URL?
    var computeUnit: MetaComputeUnit
    
    var cpuTimer: Timer = Timer()
    
    required init(unit: MetaComputeUnit) {
        computeUnit = unit
        
        currentLatency = 0.0
        currentEnegyConsumption = 0.0
        currentCpuUsage = 0.0
        
        backendUrl = nil
        
        cpuTimer = Timer.schedule(repeatInterval: 0.1) { _ in
            self.currentCpuUsage = SystemServices().cpuUsage
            print(SystemServices().cpuUsage)
        }
        
        
    }

    func start() {
        computeUnit.compute()
    }
    
    func start(action: (Any) -> Any) {
        computeUnit.compute(action: action)
    }
    
    deinit {
        cpuTimer.invalidate()
    }
}

//extension MetaComputeUnitSchedulable {
//    
//    init(unit: MetaComputeUnit) {
//        self.init()
//        computeUnit = unit
//    }
//    
//    func start() {
//        computeUnit.compute()
//    }
//    
//    func start(action: (Any) -> Any) {
//        computeUnit.compute(action: action)
//    }
//    
//}
