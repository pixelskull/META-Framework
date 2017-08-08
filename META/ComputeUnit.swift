//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 30.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol ComputeUnit {
    
    var delegate: ComputeUnitDelegate! { get set }
    
    func compute(data: Any) -> Any
}

