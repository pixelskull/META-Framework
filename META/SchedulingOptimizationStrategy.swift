//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 09.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/// protocol for newly implemented optimizations (based on AdaptiveSchedulingStrategy)
protocol SchedulingOptimizationStrategy {
    /// function for the optimization step
    func optimize()
    /// get the in **optimize()** computed values
    func getOptimizedValues() -> (Double, Double)
    
}
