//
//  MetaComputeUnitScheduler.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices


struct SchedulingValue {
    let value: Float
    let timestamp: TimeInterval
}

typealias Latency = SchedulingValue
typealias CpuUsage = SchedulingValue
typealias BatterieLevel = SchedulingValue
typealias EnergyConsumtion = Float


protocol MetaComputeUnitSchedulable {
    
    var computeUnit: MetaComputeUnit { get set } // TODO: make this const
    
    var backendUrl: URL? { get set }
    
    var currentLatency: Latency? { get }
    var currentEnegyConsumption: EnergyConsumtion? { get }
    var currentCpuUsage: CpuUsage? { get }
    
    init(unit: MetaComputeUnit)
    
    func start()
    func start(action: (Any) -> Any)
}

class MetaComputeScheduler: MetaComputeUnitSchedulable {
    
    private var latencyCheckTimer: Timer!
    private var latencies = [Latency]()
    var currentLatency: Latency? {
        get { return latencies.last }
    }
    
    private var energyTimer: Timer!
    private var energyConsumptions = [BatterieLevel]()
    var currentEnegyConsumption: EnergyConsumtion? {
        get {
            let size = energyConsumptions.count
            let latest = energyConsumptions[size-1..<size]
            
            let sum = latest.reduce(0.0) { $0 + $1.value }
            let sub = latest.reduce(0.0) { $0 - $1.value }
            
            return (sub / (sum/2)) * 100
        }
    }
    
    var cpuTimer: Timer!
    var cpuUsages = [CpuUsage]()
    var currentCpuUsage: CpuUsage? {
        get { return cpuUsages.last }
    }
    
    var backendUrl: URL?
    var computeUnit: MetaComputeUnit
    
    
    required init(unit: MetaComputeUnit) {
        computeUnit = unit
        backendUrl = nil
        
        // set initial value due to latency in timer start
        cpuUsages.append(createCpuUsageEntry())
        setupCpuTimer()
        
        // set initial value due to latency in timer start
        energyConsumptions.append(createBatterieLevelEntry())
        setupEnegryTimer()
        
        appendLatencyEntry()
        setupLatencyTimer()
    }
    
    private func setupCpuTimer() {
        cpuTimer = Timer.schedule(repeatInterval: Constants.cpuTimerInterval) { _ in
            self.cpuUsages.append(self.createCpuUsageEntry())
        }
    }
    
    private func createCpuUsageEntry() -> CpuUsage {
        return CpuUsage(value: SystemServices().cpuUsage,
                        timestamp: Date().timeIntervalSince1970)
    }
    
    private func setupEnegryTimer() {
        energyTimer = Timer.schedule(repeatInterval: Constants.energyTimerInterval) { _ in
            self.energyConsumptions.append(self.createBatterieLevelEntry())
        }
    }
    
    private func createBatterieLevelEntry() -> BatterieLevel {
        return BatterieLevel(value: SystemServices().batteryLevel,
                             timestamp: Date().timeIntervalSince1970)
    }
    
    private func setupLatencyTimer() {
        latencyCheckTimer = Timer.schedule(repeatInterval: Constants.latencyTimerInterval) { _ in
            self.appendLatencyEntry()
        }
    }
    
    private func appendLatencyEntry() {
        NetworkLatencyService.getLatency(to: "http://google.de") { latency in
            let latency = Latency(value: Float(latency),
                                  timestamp: Date().timeIntervalSince1970)
            self.latencies.append(latency)
        }
    }

    func start() {
        while computeUnit.dataSource.hasNextElement() {
            computeUnit.compute()
        }
    }
    
    func start(action: (Any) -> Any) {
        while computeUnit.dataSource.hasNextElement() {
            // TODO: implement the scheduling here
            computeUnit.compute(action: action)
        }
    }
    
    deinit {
        cpuTimer.invalidate()
        energyTimer.invalidate()
        latencyCheckTimer.invalidate()
    }
}
