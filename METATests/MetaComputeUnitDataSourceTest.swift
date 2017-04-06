//
//  MetaComputeUnitDataSourceTest.swift
//  META
//
//  Created by Pascal Schönthier on 06.04.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import XCTest
@testable import META

class MetaComputeUnitDataSourceTest: XCTestCase {
    
    let testData1 = [1, 2, 3, 4]
    let testData2 = [9, 8, 7, 6]
    
    func initDataSourceWithTestData(_ data: [Any]) -> MetaComputeDataSource{
        return MetaComputeDataSource(data: data)
    }

    func testDataSourceInit() {
        let dataSource = initDataSourceWithTestData(testData1)
        
        XCTAssertEqual(dataSource.data as! [Int], testData1)
        XCTAssertTrue(dataSource.results.isEmpty)
    }
    
    func testGetElement() {
        let dataSource = initDataSourceWithTestData(testData2)
        XCTAssertEqual(dataSource.getNextElement() as! Int, testData2.first!)
    }
    
    func testGetElementPerformance() {
        let dataSource = initDataSourceWithTestData(testData2)
        self.measure {
            (0..<100000).forEach { _ in
                _ = dataSource.getNextElement()
            }
        }
    }
    
    func testStoreResult() {
        let dataSource = initDataSourceWithTestData(testData2)
        dataSource.storeNextResult(testData1.first!)
        XCTAssertEqual(dataSource.getNextResult() as! Int, testData1.first!)
    }
    
    func testStoreResultPerformance() {
        let dataSource = initDataSourceWithTestData(testData2)
        self.measure {
            (0..<100000).forEach { _ in
                dataSource.storeNextResult(self.testData1.first!)
            }
        }
    }
    
    
    
    func testMultithreadAccessPerformance() {
        let dataSource = initDataSourceWithTestData(testData1)
        self.measure {
            (0...100000).forEach { _ in
                DispatchQueue.main.async {
                    let element = dataSource.getNextElement()
                    dataSource.storeNextResult(element ?? 1)
                }
            }
        }
    }
    
}
