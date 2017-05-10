//
//  EnergyEffizientOptimizer.swift
//  META
//
//  Created by Pascal Schönthier on 09.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import Darwin

class LatencyEffizientOptimizer: SchedulingOptimizationStrategy {
    
    private var localCompFactor:  Double {
        set {
            executeWithSemaphoreProtection {
                self.localCompFactor = newValue
                remoteCompFactor = 1.0 - newValue
            }
        }
        get {
            semaphore.wait()
            let value = self.localCompFactor
            semaphore.signal()
            return value
        }
    }
    private var remoteCompFactor: Double {
        set {
            executeWithSemaphoreProtection {
                self.remoteCompFactor = newValue
                localCompFactor = 1.0 - newValue
            }
        }
        get {
            semaphore.wait()
            let value = self.remoteCompFactor
            semaphore.signal()
            return value
        }
    }
    
    private var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    private let stepSize: Double
    
    init(localFactor: Double = 0.5, remoteFactor: Double = 0.5, stepSize: Double = 0.05) {
        self.stepSize = stepSize
        guard remoteFactor == 0.5 else {
            remoteCompFactor = remoteFactor
            return
        }
        localCompFactor = localFactor
    }
    
    /// takes an closure and executes this one protected by semaphore
    func executeWithSemaphoreProtection(_ handler: () -> Void) {
        semaphore.wait()
        handler()
        semaphore.signal()
    }
    
    /** 
     * performes the implemented optimization and updates the local and remote
     * computation factors (get them using getOptimizedValues() method)
     */
    func optimize() {
        NetworkLatencyService.getLatency(to: "www.google.de") {
            let currentLatency = $0
            let historicalLatency = 100.0 // TODO: add the right value here
            switch historicalLatency - currentLatency {
            case 0: // do nothing
                break
            case Double.leastNormalMagnitude..<0: // get more done localy
                self.localCompFactor += self.stepSize
                break
            case 0...Double.greatestFiniteMagnitude: // get more done remotely (0 excluded due to first case )
                self.localCompFactor -= self.stepSize
                break
            default:
                break
            }
        }
    }
    
    /// returns tupel of (local, remote) computation factor 
    func getOptimizedValues() -> (Double, Double) {
        return (localCompFactor, remoteCompFactor)
    }
    
}
