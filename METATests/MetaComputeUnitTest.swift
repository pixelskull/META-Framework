////
////  MetaComputeUnitTest.swift
////  META
////
////  Created by Pascal Schönthier on 04.04.17.
////  Copyright © 2017 Pascal Schönthier. All rights reserved.
////
//
//import XCTest
//@testable import META
//
//
//class MetaComputeUnitTest: XCTestCase {
//    
//    func testInitMetaComputeUnit() {
//        let dataSource = MetaComputeDataSource()
//        let unit:MetaComputeUnit = MetaComputeUnit(delegate: nil, dataSource: dataSource)
//        
//        assert(unit.dataSource === dataSource)
//    }
//    
//    func testMetaComputeUnitComputeClosure() {
//        // setup datasource
//        let data = [4, 5, 6, 7, 8, 1, 2, 3, 4]
//        let dataSource = MetaComputeDataSource(data: data as [AnyObject])
//        
//        let unit = MetaComputeUnit(delegate: nil, dataSource: dataSource)
//    
//        unit.computeAll { value in
//            return value as! Int + 1
//        }
//        
//        XCTAssertEqual(dataSource.results as! [Int], [5, 6, 7, 8, 9, 2, 3, 4, 5])
//    }
//    
//    func testMetaComputeUnitComputeClosurePerformance() {
//        
//        // setup datasource
//        let data = [4, 5, 6, 7, 8, 1, 2, 3, 4]
//        let dataSource = MetaComputeDataSource(data: data as [AnyObject])
//        
//        let unit = MetaComputeUnit(delegate: nil, dataSource: dataSource)
//        
//        self.measure {
//            unit.computeAll { value in
//                return value as! Int + 1
//            }
//        }
//    }
//    
//    func testMetaComputeUnitDefaultCompute() {
//        let data = [1, 2, 3, 4, 5, 6]
//        let dataSource = MetaComputeDataSource(data: data as [AnyObject])
//        
//        let unit = MetaComputeUnit(delegate: nil, dataSource: dataSource)
//        
//        unit.computeAll()
//        
//        XCTAssertEqual(dataSource.results as! [Int], data)
//    }
//    
//    func testMetaComputeUnitDefaultComputePerformance() {
//        let data = [1, 2, 3, 4, 5, 6]
//        let dataSource = MetaComputeDataSource(data: data as [AnyObject])
//        
//        let unit = MetaComputeUnit(delegate: nil, dataSource: dataSource)
//        
//        self.measure {
//            unit.computeAll()
//        }
//    }
//
//}

