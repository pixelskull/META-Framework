//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 09.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol SchedulingOptimizationStrategy {
    
    func optimize()
    
    func getOptimizedValues() -> (Double, Double)
    
}
