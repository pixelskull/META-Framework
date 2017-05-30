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
    
    
    init(delegate: MetaComputeUnitDelegate?)
    
    func compute<T>(data: T) -> T
    func compute<T>(data:T, WithAction action: (T) -> T) -> T
    
}


struct MetaComputeUnit: MetaComputeUnitable {
    
    var delegate: MetaComputeUnitDelegate?
    
    
    init(delegate: MetaComputeUnitDelegate?) {
        self.delegate   = delegate
    }
    
    func updateDelegate(WithResult result: Any) {
        guard let delegate = delegate else { return }
        delegate.computeUnitUpdatedResults()
        delegate.computeUnitCompletedResult(result)
    }
    
    /// Default implementation does nothing
    func compute<T>(data:T) -> T {
        updateDelegate(WithResult: data)
        return data
    }
    
    func compute<T>(data:T, WithAction action: (T) -> T) -> T {
        let result = action(data)
        updateDelegate(WithResult: result)
        return result
    }
}
