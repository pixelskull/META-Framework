//
//  MetaComputeUnitDelegate.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol MetaComputeUnitDelegate {
    
    func computeUnitUpdatedResults()
    
    func computeUnitCompletedResult(_ result:Any)
    
    func computeFailedProducingResults(element: Any, error: Error)
    
    // TODO: add needfull stuff
    
}
