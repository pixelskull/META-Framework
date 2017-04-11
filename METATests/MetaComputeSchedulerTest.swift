//
//  MetaComputeSchedulerTest.swift
//  META
//
//  Created by Pascal Schönthier on 11.04.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import XCTest
@testable import META

class MetaComputeSchedulerTest: XCTestCase {
    
    func testInitialization() {
        let cu = MetaComputeUnit(delegate: nil, dataSource: MetaComputeDataSource(data: [1, 2, 4, 5]))
        let scheduler = MetaComputeScheduler(unit: cu)
        
        XCTAssert(scheduler.computeUnit == cu, "Initialisation is not successfully: compute unit not valid")
    }
    
}
