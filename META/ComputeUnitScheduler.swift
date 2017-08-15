//
//  MetaComputeUnitScheduler.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices


/// Struct for storing scheduling related values.
/// **value** is used for values that are used to help the scheduler make a decision.
/// **timestamp** time for the given value (if value is time relevant).
struct SchedulingValue {
    let value: Float
    let timestamp: TimeInterval
}


/// Value for scoring network latency
typealias Latency = SchedulingValue
/// cpu usage as percent (0.0 - 1.0)
typealias CpuUsage = SchedulingValue
/// current batterie status in percent (0.0 - 1.0)
typealias BatterieLevel = SchedulingValue
/// power consumtion in percent (0.0 - 1.0)
typealias EnergyConsumtion = Float


/** Protocol definition for Scheduling implementations
 defines the function **start** also gives the global variables **computeUnit**,
 **backendURL** (optional) and **dataSource**
*/
protocol MetaComputeUnitSchedulable {
    /// **ComputeUnit** Implementation to use with scheduler
    var computeUnit: ComputeUnit { get set }
    /// URL to backend server in URL format
    var backendUrl: URL? { get set }
    /// **MetaComputeDataSource** Implementation for handling values and results
    var dataSource: MetaComputeDataSource { get set }
    
    /** Initializes an instance and sets the given values
     - parameters:
         - unit: ComputeUnit Instance used for computing new results
         - dataSource: DataSource that handles the compute values
         - serverURL: URL to backend server as String
    */
    init(unit: ComputeUnit, dataSource: MetaComputeDataSource, serverURL: String)
    
    
    /// this function starts the computation
    func start()
}


/// Default implementation for the **MetaComputeUnitSchedulable** protocol
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

        self.scheduler = RoundRobinSchedulingStrategy(withDataSource: dataSource,
                                                      basedOn: computeUnit)
    }

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
    
    // stops the scheduling via scheduler implementation
    func stop() { scheduler.stop() }
    
}
