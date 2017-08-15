//
//  MetaComputeUnitDelegate.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/**
 Protocol used to define an delegate class for **ComputeUnit**
 */
protocol ComputeUnitDelegate {
    /// gets called everytime a new result is set
    func computeUnitUpdatedResults()
    /// gets called everytime a new result is set. Gives you direct access to the element.
    func computeUnitCompletedResult(_ result:Any)
    /// gets called if something went wrong **not implemented yet**
    func computeFailedProducingResults(element: Any, error: Error)
}
