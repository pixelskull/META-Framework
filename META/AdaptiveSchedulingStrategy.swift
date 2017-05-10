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
    private var _dataSource: MetaComputeDataSource
    var dataSource: MetaComputeDataSource {
        get { return _dataSource }
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
    var optimizationAlgortihm : SchedulingOptimizationStrategy? {
        get { return _optimizationAlgortihm }
    }
    
    private let dataChunkSize:Int = 10
    
    // MARK: Initializer(s)
    init(withLocalComputationFaktor faktor : Double,
         basedOn dataSource:MetaComputeDataSource,
         optimizedFor parameter : OptimizingParameter = .EnergyEfficency) {
        
        _dataSource = dataSource
        _localCompFaktor = faktor
        
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
        default:
            _optimizationAlgortihm = LatencyEffizientOptimizer()
            break
        }
    }
    
    // MARK: Operations
    func schedule() {
        let (local, _) = (optimizationAlgortihm?.getOptimizedValues())!
        
        let upperLocalBound:Int = Int( round(Double(dataChunkSize)/local) )
        let valuesToComputeLocally  = ( 0 ..< upperLocalBound ).map { _ in
            self.dataSource.getNextElement()
        }
        let valuesToComputeRemotely = ( upperLocalBound ... dataChunkSize ).map { _ in
            self.dataSource.getNextElement()
        }
        
        print(valuesToComputeLocally)
        print(valuesToComputeRemotely)
        // TODO: add operation here
    }
    
    
}
