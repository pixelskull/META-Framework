//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 30.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/// protocol for implementing your own ComputeUnit
protocol ComputeUnit {
    /// delegate class for getting results
    var delegate: ComputeUnitDelegate! { get set }
    
    init()
    /// compute function, this is were your magic happens
    func compute(data: Any) -> Any
}

/**
 Really dumb dummy implementation, there is nothing more to say...
 */
public class ComputeUnitTest: ComputeUnit {
    var delegate: ComputeUnitDelegate!
    
    public required init() {}
    
    public func compute(data: Any) -> Any {
        return data 
    }
}

