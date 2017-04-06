//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 30.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol MetaComputeUnitable {
    
    var delegate: MetaComputeUnitDelegate? { get set }
    var dataSource: MetaComputeDataSource { get set }
    
    
    init(delegate: MetaComputeUnitDelegate?, dataSource: MetaComputeDataSource)
    
    func compute()
    func compute(action: (Any) -> Any)
    func computeAll(action: (Any) -> Any)
    
}


struct MetaComputeUnit: MetaComputeUnitable {
    
    var delegate: MetaComputeUnitDelegate?
    var dataSource: MetaComputeDataSource
    
    
    init(delegate: MetaComputeUnitDelegate?, dataSource:MetaComputeDataSource) {
        self.dataSource = dataSource
        self.delegate   = delegate
    }
    
    func updateDelegate(WithResult result: Any) {
        guard let delegate = delegate else { return }
        delegate.computeUnitUpdatedResults()
        delegate.computeUnitCompletedResult(result)
    }
    
    func compute() {
        if let result = dataSource.getNextElement() {
            dataSource.storeNextResult(result)
            updateDelegate(WithResult: result)
        }
    }
    
    func computeAll() {
        guard !dataSource.data.isEmpty else { return }
        dataSource.data.forEach{ element in
            let result = element
            dataSource.storeNextResult(result)
            updateDelegate(WithResult: result)
        }
    }
    
    func compute(action: (Any) -> Any) {
        if let element = dataSource.getNextElement() {
            let result = action(element)
            dataSource.storeNextResult(result)
            updateDelegate(WithResult: result)
        }
    }
    
    func computeAll(action: (Any) -> Any) {
        guard !dataSource.data.isEmpty else { return }
        dataSource.data.forEach{ element in
            let result = action(element)
            dataSource.storeNextResult(result)
            updateDelegate(WithResult: result)
        }
    }
    
}

//extension MetaComputeUnit {
//    
//    init(delegate: MetaComputeUnitDelegate, dataSource:MetaComputeDataSource) {
//        self.init()
//        self.dataSource = dataSource
//        self.delegate   = delegate
//    }
//    
//    func compute() {
//        if let result = dataSource.getNextElement() {
//            dataSource.storeNextResult(result)
//            
//            // sending update to delegate
//            delegate.computeUnitUpdatedResults()
//            delegate.computeUnitCompletedResult(result)
//        }
//    }
//    
//    func compute(action: (Any) -> Any) {
//        if let element = dataSource.getNextElement() {
//            let result = action(element)
//            dataSource.storeNextResult(result)
//            
//            // sending update to delegate
//            delegate.computeUnitUpdatedResults()
//            delegate.computeUnitCompletedResult(result)
//        }
//    }
//    
//}

