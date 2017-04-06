//
//  MetaComputeUnitScheduler.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

typealias Latency = Double
typealias EnergyConsumtion = Double

protocol MetaComputeUnitSchedulable {
    
    var computeUnit: MetaComputeUnit { get set } // TODO: make this const
    
    var backendUrl: URL? { get set }
    
    var currentLatency: Latency { get set }
    var currentEnegyConsumption: EnergyConsumtion { get set }
    
    init(unit: MetaComputeUnit)
    
    func start()
    func start(action: (Any) -> Any)
}

struct MetaComputeScheduler: MetaComputeUnitSchedulable {
    
    var currentLatency: Latency
    var currentEnegyConsumption: EnergyConsumtion
    
    var backendUrl: URL?
    var computeUnit: MetaComputeUnit
    
    init(unit: MetaComputeUnit) {
        computeUnit = unit
        
        currentLatency = 0.0
        currentEnegyConsumption = 0.0
        backendUrl = nil
    }

    func start() {
        computeUnit.compute()
    }
    
    func start(action: (Any) -> Any) {
        computeUnit.compute(action: action)
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
