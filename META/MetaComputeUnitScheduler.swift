//
//  MetaComputeUnitScheduler.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import iOSSystemServices

struct Latency {
    let value: Float
    let timestamp: TimeInterval
}

struct EnergyConsumtion {
    let value: Float
    let timestamp: TimeInterval
}

struct CpuUsage {
    let value: Float
    let timestamp: TimeInterval
}

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
    
    var latencyCheckTimer: Timer!
    var latencies = [Latency]()
    var currentLatency: Latency? {
        get { return latencies.last }
    }
    
    var energyTimer: Timer!
    var energyConsumptions = [EnergyConsumtion]()
    var currentEnegyConsumption: EnergyConsumtion? {
        get { return energyConsumptions.last }
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
        energyConsumptions.append(createEnergyConsumtionEntry())
        setupEnegryTimer()
    }
    
    private func setupCpuTimer() {
        cpuTimer = Timer.schedule(repeatInterval: 0.2) { _ in
            self.cpuUsages.append(self.createCpuUsageEntry())
        }
    }
    
    private func createCpuUsageEntry() -> CpuUsage {
        return CpuUsage(value: SystemServices().cpuUsage,
                        timestamp: Date().timeIntervalSince1970)
    }
    
    private func setupEnegryTimer() {
        energyTimer = Timer.schedule(repeatInterval: 0.5) { _ in
            print(self.createEnergyConsumtionEntry().value)
            self.energyConsumptions.append(self.createEnergyConsumtionEntry())
        }
    }
    
    private func createEnergyConsumtionEntry() -> EnergyConsumtion {
        return EnergyConsumtion(value: SystemServices().batteryLevel,
                                timestamp: Date().timeIntervalSince1970)
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
    }
}
