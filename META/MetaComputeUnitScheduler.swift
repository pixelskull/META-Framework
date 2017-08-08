//
//  MetaComputeUnitScheduler.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices


struct SchedulingValue {
    let value: Float
    let timestamp: TimeInterval
}

typealias Latency = SchedulingValue
typealias CpuUsage = SchedulingValue
typealias BatterieLevel = SchedulingValue
typealias EnergyConsumtion = Float


protocol MetaComputeUnitSchedulable {
    
    var computeUnit: MetaComputeUnit { get set } // TODO: make this const
    
    var backendUrl: URL? { get set }
    
    var dataSource: MetaComputeDataSource { get set }
    
    init(unit: MetaComputeUnit, dataSource: MetaComputeDataSource)
    
    func start()
    func start(action: @escaping (Any) -> Any)
}

class MetaComputeScheduler: MetaComputeUnitSchedulable {
    
    // MARK: Properties
    
    // setting up observer with notifier
//    let cpuNotifier = CPUUsageNotifier()
//    let latencyNotifier = LatencyNotifier()
//    let batteryNotifier = BatterieLevelNotifier()
    
    var backendUrl: URL?
    
    var computeUnit: MetaComputeUnit
    var dataSource: MetaComputeDataSource
    
    var scheduler: SchedulingStrategy!
    
    // MARK: Initializer
    required init(unit: MetaComputeUnit, dataSource: MetaComputeDataSource) {
        self.computeUnit = unit
        self.dataSource  = dataSource
        self.backendUrl = nil
        
        self.scheduler = AdaptiveSchedulingStrategy(withLocalComputationFactor: 0.5,
                                                    withDataSource: dataSource,
                                                    basedOn: computeUnit)
    }
    
    // MARK: Private instance functions

    // MARK: Interfaced functions
    
    /**
     lets you start the computation with distribution and management
     starts with local/remote computation factor 0.5
     
     **requires configurated DataSource and ComputeUnit**
    */
    func start() {
        scheduler = AdaptiveSchedulingStrategy(withLocalComputationFactor: 0.5,
                                               withDataSource: dataSource,
                                                   basedOn: computeUnit)
        scheduler.schedule()
    }
    
    func start(action: @escaping (Any) -> Any) {
        while dataSource.hasNextElement() {
            // TODO: implement the scheduling here
            let result = computeUnit.compute(data: dataSource.getNextElement()!, WithAction: action)
            dataSource.storeNextResult(result)
        }
    }
    
    func stop() { scheduler.stop() }
    
}
