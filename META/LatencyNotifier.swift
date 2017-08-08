////
////  LatencyObserver.swift
////  META
////
////  Created by Pascal Schönthier on 30.05.17.
////  Copyright © 2017 Pascal Schönthier. All rights reserved.
////
//
//import Foundation
//
//class LatencyNotifier {
//    
//    let observer: Observable!
//    
//    
//    private var latencyCheckTimer: Timer!
//    private var latencies = [Latency]() {
//        willSet(newValue) {
//            observer.willChange(propertyName: "latenciesWillChange", newPropertyValue: newValue)
//        }
//        
//        didSet {
//            observer.didChange(propertyName: "latenciesDidChange", oldPropertyValue: oldValue)
//        }
//    }
//    
//    var currentLatency: Latency? {
//        get { return latencies.last }
//    }
//    
//    init() {
//        observer = DefaultObserver()
//        setupLatencyTimer()
//    }
//    
//    private func setupLatencyTimer() {
//        latencyCheckTimer = Timer.schedule(repeatInterval: Constants.latencyTimerInterval) { _ in
//            self.appendLatencyEntry()
//        }
//    }
//    
//    private func appendLatencyEntry() {
//        NetworkLatencyService.getLatency(to: "http://google.de") { latency in
//            let latency = Latency(value: Float(latency),
//                                  timestamp: Date().timeIntervalSince1970)
//            self.latencies.append(latency)
//        }
//    }
//    
//    deinit {
//        latencyCheckTimer.invalidate()
//    }
//}

