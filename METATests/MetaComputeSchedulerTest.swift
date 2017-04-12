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
    
    var scheduler:MetaComputeScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = initDefaultScheduler()
    }
    
    override func tearDown() {
        Thread.sleep(forTimeInterval: 0.1)
        super.tearDown()
    }
    
    func initDefaultScheduler() -> MetaComputeScheduler {
        let cu = MetaComputeUnit(delegate: nil, dataSource: MetaComputeDataSource(data: [1, 2, 4, 5]))
        return MetaComputeScheduler(unit: cu)
    }
    
    func wait(withTimeout timeOut:TimeInterval, forCondition condition:@escaping () -> Bool) {
        let finishingTime = Date().timeIntervalSince1970 + timeOut
        while true {
            let currentTime = Date().timeIntervalSince1970
            if  condition() ||
                (finishingTime - currentTime == 0) {
                break
            }
        }
    }
    
    func testCpuTimer() {
        XCTAssert(scheduler.cpuTimer.isValid, "CPU Timer was not created successfully and is not valid")
    }
    
    func testCurrentCpuUsage() {
//        Thread.sleep(forTimeInterval: 10.0)
//        XCTAssert((scheduler.currentCpuUsage != nil), "CPU usage was not updated")
        wait(withTimeout: 1.0) { self.scheduler.currentCpuUsage != nil }
        XCTAssert((scheduler.currentCpuUsage != nil), "CPU usage value was not updated")
    }
    
    func testCurrentEnergyConsumption() {
        wait(withTimeout: 1.0) { self.scheduler.currentEnegyConsumption != nil }
        XCTAssert(scheduler.currentEnegyConsumption != nil, "Energy consumption value was not updated")
    }
    
    // TODO: activate this test when network is usefull 
//    func testCurrentLatency() {
//        wait(withTimeout: 1.0) { self.scheduler.currentLatency != nil }
//        XCTAssert(scheduler.currentLatency != nil, "Latency value was not updated")
//    }
    
    func testBackendURL() {
        let dummyURL = URL(string: "http://test.com/testingURL")
        scheduler.backendUrl = dummyURL
        
        XCTAssert(scheduler.backendUrl == dummyURL, "BackendURL was not set properly")
    }
    
    func testSchedulerStartDefaultImplementation(){
        let data = scheduler.computeUnit.dataSource.data
        scheduler.start()
        
        let dataSource = scheduler.computeUnit.dataSource
        XCTAssertEqual(data as! [Int], dataSource.results as! [Int])
    }
    
    func testSchedulerStartWithClosure() {
        scheduler.start {
            return $0 as! Int * 2
        }
        
        let dataSource = scheduler.computeUnit.dataSource
        XCTAssertEqual(dataSource.results as! [Int], [2, 4, 8, 10])
    }
}
