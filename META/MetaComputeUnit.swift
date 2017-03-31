//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 30.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol MetaComputeUnit {
    
    var delegate: MetaComputeUnitDelegate { get set }
    var dataSource: MetaComputeDataSource { get set }
    
    init(delegate: MetaComputeUnitDelegate, dataSource: MetaComputeDataSource)
    
    func compute()
    
    func compute(action: (Any) -> Any)
}

extension MetaComputeUnit {
    
    func compute() {
        if let result = dataSource.getNextElement() {
            dataSource.storeNextResult(result)
            
            // sending update to delegate
            delegate.computeUnitUpdatedResults()
            delegate.computeUnitCompletedResult(result)
        }
    }
    
    func compute(action: (Any) -> Any) {
        if let element = dataSource.getNextElement() {
            let result = action(element)
            dataSource.storeNextResult(result)
            
            // sending update to delegate
            delegate.computeUnitUpdatedResults()
            delegate.computeUnitCompletedResult(result)
        }
    }
    
}

class ComputeUnit:MetaComputeUnit {
    
    var dataSource: MetaComputeDataSource
    var delegate: MetaComputeUnitDelegate
    
    required init(delegate: MetaComputeUnitDelegate, dataSource: MetaComputeDataSource) {
        self.delegate   = delegate
        self.dataSource = dataSource
    }
    
}
