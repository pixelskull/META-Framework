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
    /**
     factor for remote computation **manipulates
     remoteCompFactor** when set to normalize to
     1.0c
     */
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
    
    /**
     factor for remote computation **manipulates
     localCompFactor** when set to normalize to
     1.0
    */
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
    
    /// Flag if latency was messured already
    private var latencyMessured = false
    /// Duplicate of currentLatencies feeded from LatencyNotifier
    private var currentLatencies:[Latency]?
  
    /// Simple semaphore used for secure access to localCompFactor and remoteCompFactor
    private var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    /// Constant for incrementing or decrementing the computation factors
    private let stepSize: Double
    
    init(localFactor: Double = 0.5, remoteFactor: Double = 0.5, stepSize: Double = 0.05) {
        self.stepSize = stepSize
        guard remoteFactor == 0.5 else {
            remoteCompFactor = remoteFactor
            return
        }
        localCompFactor = localFactor
        
        // adding observer to notification center for latenciesWillChange notification
        let notificationName = Notification.Name(rawValue: "latenciesWillChange")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LatencyEffizientOptimizer.handleLatencyMessage),
                                               name: notificationName,
                                               object: nil)
    }
    
    /// callback function for notificationCenter
    @objc private func handleLatencyMessage(_ notification: Notification) {
        guard let latency = notification.object as? [Latency] else { return }
        if !latencyMessured { latencyMessured = true }
        currentLatencies = latency
    }
    
    
    /**
     Takes an clusure and executes the closure with protection of a semaphore
     **used for setting local and remote computation factor**
     
     - Parameter handler: Closure for manipulating remoteCompFactor or localCompFactor
    */
    private func executeWithSemaphoreProtection(_ handler: () -> Void) {
        semaphore.wait()
        handler()
        semaphore.signal()
    }
    
    /**
     Calculates the average latency over the given array of Latency values
     
     - Parameter values: Array with Latency values
     - returns: average latency
    */
    private func average(latency values:[Latency]) -> Float {
        let sum = values.reduce(0.0) { (result:Float, nextValue:Latency) -> Float in
            return result + nextValue.value
        }
        return sum / Float(values.count)
    }
    
    /**
      performes the implemented optimization and updates the local and remote
      computation factors *get them using .getOptimizedValues() method*
     */
    func optimize() {
        while !latencyMessured { sleep(1) } // TODO: is waiting nessesary?
        
        // if no Latencies Messured compute local only
        guard let currentLatencies = currentLatencies else {
            localCompFactor = 1.0
            return
        }
        
        let lastLatency = currentLatencies.last?.value
        let averageLatency = average(latency: currentLatencies)
        
        switch lastLatency {
        case _ where lastLatency! < averageLatency:
            localCompFactor = localCompFactor - stepSize
            break
        case _ where lastLatency! > averageLatency:
            localCompFactor = localCompFactor + stepSize
            break
        default:
            break
        }
    }

    /**
     getter for local and remote computation factors computed by method *.optimize()*
     - returns: tupel with remote and local computation **(local, remote)**
    */
    func getOptimizedValues() -> (Double, Double) {
        return (localCompFactor, remoteCompFactor)
    }
    
}
