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
    
    func hasNextElement() -> Bool
    func getNextElement() -> Any?
    
    func hashNextResult() -> Bool
    func getNextResult() -> Any?
    
    func storeNextResult(_ result: Any)
    
}

enum MetaComputeUnitDataSourceDataSet {
    case Result
    case Data
}

class MetaComputeDataSource: MetaComputeDataSourceable, Equatable {
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
        guard !data.isEmpty else { return nil }
        semaphore.wait()
        let result: Any?
        switch dataSet {
        case .Result:
            result = results.removeFirst()
        default:
            result = data.removeFirst()
        }
        semaphore.signal()

        return result
    }
    
    
    func hasNextElement() -> Bool {
        return data.first != nil
    }
    
    func getNextElement() -> Any? {
        return getElementFrom(dataSet: .Data, semaphore: dataSemaphore)
    }
    
    
    func hashNextResult() -> Bool {
        return results.first != nil
    }
    
    func getNextResult() -> Any? {
        return getElementFrom(dataSet: .Result, semaphore: resultSemaphore)
    }
    
    
    func storeNextResult(_ result: Any) {
        resultSemaphore.wait()
        results.append(result)
        resultSemaphore.signal()
    }
    
    /// TODO: statisfy this problem (don't use Protocols and work generic)
    public static func ==(lhs: MetaComputeDataSource, rhs: MetaComputeDataSource) -> Bool{
        return lhs.data.count == rhs.data.count &&
               lhs.results.count == rhs.results.count
    }
}
