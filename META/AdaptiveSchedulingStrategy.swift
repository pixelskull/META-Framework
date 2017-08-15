//
//  AdaptiveSchedulingStrategie.swift
//  META
//
//  Created by Pascal Schönthier on 03.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation


/// Enumeration values for Scheduling optimization:
enum OptimizingParameter {
    case EnergyEfficency
    case CPUHighUsageBoost
    case CPUIdleUsageBoost
    case Lowlatency
}

/**
 First try to implement a more adaptive method for the scheduling. **Currently not working
 due to issues with the sensoric.** Also this did have some issues in optimizing.
 
 Tries to find the optimum between power consumption and compute power in four ways:
 - CPUHighUsageBoost: max performance mode
 - CPUIdleUsageBoost: batterie saving mode with high server support
 - EnergyEfficency: try to use not too much computation power
 - LowLatency: optimizes to compute as much as get on server
 */
struct AdaptiveSchedulingStrategy : SchedulingStrategy {
    
    // MARK: Properties
    
    /// private storage for compute unit to conform to protocol
    private var _computeUnit: ComputeUnit
    /// public getter for compute unit
    var computeUnit: ComputeUnit {
        get { return _computeUnit }
    }
    
    /// private storage for local compute factor
    private var _localCompFaktor : Double
    /// private getter and setter property for local compute factor
    private var localCompFaktor : Double{
        get { return self.localCompFaktor }
        set {
            self.localCompFaktor    = newValue
            self.remoteCompFaktor   = 1.0 - newValue
        }
    }
    
    /// private getter and setter property for remote compute factor
    private var remoteCompFaktor : Double {
        get { return self.remoteCompFaktor }
        set { self.remoteCompFaktor = newValue }
    }
    
    /// private propertie for used Strategy
    private var _optimizationAlgortihm: SchedulingOptimizationStrategy?
    /// public getter for optimization strategie
    var optimizationAlgortihm : SchedulingOptimizationStrategy! {
        get { return _optimizationAlgortihm }
    }
    
    /// private propertie to hold the datasource
    private var dataSource: MetaComputeDataSource
    
    /// property for defining size of chunks that the data is crunched in
    private let dataChunkSize:Int = 10
    /// private variable for stopping operation
    private var operate:Bool = true
    
    // MARK: Initializer(s)
    init(withLocalComputationFactor faktor: Double,
         withDataSource data: MetaComputeDataSource,
         basedOn computeUnit: ComputeUnit,
         optimizedFor parameter: OptimizingParameter = .EnergyEfficency) {
        
        _computeUnit = computeUnit
        _localCompFaktor = faktor
        dataSource = data
        
        /// set optimization strategy
        switch parameter {
        case .CPUHighUsageBoost:
            _optimizationAlgortihm = nil // TODO: add right strategy here 
            break
        case .CPUIdleUsageBoost:
            _optimizationAlgortihm = nil // TODO: add right strategy here
            break
        case .EnergyEfficency:
            _optimizationAlgortihm = nil // TODO: add right strategy here
            break
        default: // .Lowlatency
            _optimizationAlgortihm = LatencyEffizientOptimizer()
            break
        }
    }
    
    // MARK: Interfaced operations
    func schedule() {
        while(operate) {
            let (local, _) = optimizationAlgortihm.getOptimizedValues()
            
            let upperLocalBound:Int = Int( round(Double(dataChunkSize)/local) )
            let valuesToComputeLocally  = ( 0 ..< upperLocalBound ).map { _ in
                self.dataSource.getNextElement()
            }
            
            let valuesToComputeRemotely = ( upperLocalBound ... dataChunkSize ).map { _ in
                self.dataSource.getNextElement()
            }
            print(valuesToComputeLocally)
            print(valuesToComputeRemotely)
        }
    }
    
    mutating func stop() { operate = false }
}
