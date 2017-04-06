//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol MetaComputeDataSourceable {
    
    var data:[Any] { get set }
    var results:[Any] { get set }
    
    var dataSemaphore:DispatchSemaphore { get set }
    var resultSemaphore:DispatchSemaphore { get set }
    
    
    init(data: [Any])
    
    func getNextElement() -> Any?
    
    func getNextResult() -> Any?
    
    func storeNextResult(_ result: Any)
    
}

enum MetaComputeUnitDataSourceDataSet {
    case Result
    case Data
}

class MetaComputeDataSource: MetaComputeDataSourceable {
    var data: [Any]       = [Any]()
    var results: [Any]    = [Any]()
    
    var dataSemaphore: DispatchSemaphore
    var resultSemaphore: DispatchSemaphore

    init() {
        dataSemaphore   = DispatchSemaphore(value: 1)
        resultSemaphore = DispatchSemaphore(value: 1)
        data            = [Any]()
        results         = [Any]()
    }
    
    required convenience init(data: [Any]) {
        self.init()
        self.data = data
    }
    
    private func getElementFrom(dataSet: MetaComputeUnitDataSourceDataSet,
                                semaphore: DispatchSemaphore) -> Any? {
        semaphore.wait()
        let result: Any?
        switch dataSet {
        case .Result:
            result = results.first
        default:
            result = data.first
        }
        semaphore.signal()

        return result
    }
    
    func getNextElement() -> Any? {
        return getElementFrom(dataSet: .Data, semaphore: dataSemaphore)
    }
    
    func getNextResult() -> Any? {
        return getElementFrom(dataSet: .Result, semaphore: resultSemaphore)
    }
    
    func storeNextResult(_ result: Any) {
        resultSemaphore.wait()
        results.append(result)
        resultSemaphore.signal()
    }
}

//extension MetaComputeDataSource {
//    
//    init() {
//        self.init()
//        dataSemaphore   = DispatchSemaphore(value: 1)
//        resultSemaphore = DispatchSemaphore(value: 1)
//        data            = [Any]()
//        results         = [Any]()
//    }
//    
//    
//    init(data: [Any]) {
//        self.init()
//        self.data = data
//    }
//    
//    
//    private func getElementFrom(dataSet: inout [Any], semaphore: DispatchSemaphore) -> Any? {
//        guard !dataSet.isEmpty else { return nil }
//        semaphore.wait()
//        let result = dataSet.removeFirst()
//        semaphore.signal()
//        return result
//    }
//    
//    
//    mutating func getNextElement() -> Any? {
//        return getElementFrom(dataSet: &data, semaphore: dataSemaphore)
//    }
//    
//    
//    mutating func getNextResult() -> Any? {
//        return getElementFrom(dataSet: &results, semaphore: resultSemaphore)
//    }
//    
//
//    mutating func storeNextResult(_ result:Any) {
//        resultSemaphore.wait()
//        results.append(result)
//        resultSemaphore.signal()
//    }
//    
//}
