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
    
    var computeUnit: ComputeUnit { get set } // TODO: make this const
    
    var backendUrl: URL? { get set }
    
    var dataSource: MetaComputeDataSource { get set }
    
    init(unit: ComputeUnit, dataSource: MetaComputeDataSource, serverURL: String)
    
    func start()
}

class ComputeScheduler: MetaComputeUnitSchedulable {

    
    // MARK: Properties
    var backendUrl: URL?
    
    var computeUnit: ComputeUnit
    var dataSource: MetaComputeDataSource
    
    var scheduler: SchedulingStrategy!
    
    // MARK: Initializer
    required init(unit: ComputeUnit,
                  dataSource: MetaComputeDataSource,
                  serverURL: String = "localhost") {
        self.computeUnit = unit
        self.dataSource  = dataSource
        self.backendUrl = URL(string: serverURL)
        
//        self.scheduler = AdaptiveSchedulingStrategy(withLocalComputationFactor: 0.5,
//                                                    withDataSource: dataSource,
//                                                    basedOn: computeUnit)
        self.scheduler = RoundRobinSchedulingStrategy(withDataSource: dataSource,
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
    
    func stop() { scheduler.stop() }
    
}
