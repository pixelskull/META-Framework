//
//  AdaptiveSchedulingStrategie.swift
//  META
//
//  Created by Pascal Schönthier on 03.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

enum OptimizingParameter {
    case EnergyEfficency
    case CPUHighUsageBoost
    case CPUIdleUsageBoost
    case Lowlatency
}

struct AdaptiveSchedulingStrategy : SchedulingStrategy {
    
    // MARK: Properties
    private var _computeUnit: MetaComputeUnit
    var computeUnit: MetaComputeUnit {
        get { return _computeUnit }
    }
    
    private var _localCompFaktor : Double
    private var localCompFaktor : Double{
        get { return self.localCompFaktor }
        set {
            self.localCompFaktor    = newValue
            self.remoteCompFaktor   = 1.0 - newValue
        }
    }
    
    private var remoteCompFaktor : Double {
        get { return self.remoteCompFaktor }
        set { self.remoteCompFaktor = newValue }
    }
    
    private var _optimizationAlgortihm: SchedulingOptimizationStrategy?
    var optimizationAlgortihm : SchedulingOptimizationStrategy! {
        get { return _optimizationAlgortihm }
    }
    
    private var dataSource: MetaComputeDataSource
    
    
    private let dataChunkSize:Int = 10
    private var operate:Bool = true
    
    // MARK: Initializer(s)
    init(withLocalComputationFactor faktor: Double,
         withDataSource data: MetaComputeDataSource,
         basedOn computeUnit: MetaComputeUnit,
         optimizedFor parameter: OptimizingParameter = .EnergyEfficency) {
        
        _computeUnit = computeUnit
        _localCompFaktor = faktor
        dataSource = data
        
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
