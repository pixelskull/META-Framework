//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

protocol MetaComputeDataSourceable {
    
    var data:[MetaComuteUnitDataSourceSet] { get set }
    var results:[MetaComuteUnitDataSourceSet] { get set }
    
    var dataSemaphore:DispatchSemaphore { get set }
    var resultSemaphore:DispatchSemaphore { get set }
    
    
    init(data: [Any])
    
    func hasNextElement() -> Bool
    func getNextElement() -> MetaComuteUnitDataSourceSet?
    
    func hashNextResult() -> Bool
    func getNextResult() -> MetaComuteUnitDataSourceSet?
    
    func storeNextResult(_ result: Any)
    
}

enum MetaComputeUnitDataSourceDataSetType {
    case Result
    case Data
}

struct MetaComuteUnitDataSourceSet {
    let id: Int
    let value: Any
}

class MetaComputeDataSource: MetaComputeDataSourceable, Equatable {
    
    var data: [MetaComuteUnitDataSourceSet] = [MetaComuteUnitDataSourceSet]()
    var results: [MetaComuteUnitDataSourceSet] = [MetaComuteUnitDataSourceSet]()
    
    var dataSemaphore: DispatchSemaphore
    var resultSemaphore: DispatchSemaphore

    init() {
        dataSemaphore   = DispatchSemaphore(value: 1)
        resultSemaphore = DispatchSemaphore(value: 1)
        data            = [MetaComuteUnitDataSourceSet]()
        results         = [MetaComuteUnitDataSourceSet]()
    }
    
    required convenience init(data: [Any]) {
        self.init()
        self.data = (0..<data.count).map {
            MetaComuteUnitDataSourceSet(id: $0, value: data[$0])
        }
    }
    
    private func getElementFrom(dataSet: MetaComputeUnitDataSourceDataSetType,
                                semaphore: DispatchSemaphore) -> MetaComuteUnitDataSourceSet? {
        guard !data.isEmpty else { return nil }
        semaphore.wait()
        let result: MetaComuteUnitDataSourceSet?
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
    
    func getNextElement() -> MetaComuteUnitDataSourceSet? {
        return getElementFrom(dataSet: .Data, semaphore: dataSemaphore)
    }
    
    func getSetOfElements(size: Int) -> [MetaComuteUnitDataSourceSet] {
        dataSemaphore.wait()
        let set = data[0..<size]
        data.removeFirst(size)
        dataSemaphore.signal()
        return Array(set)
    }
    
    func hashNextResult() -> Bool {
        return results.first != nil
    }
    
    func appendSetofResults(_ set:[Any]) {
        let dataSourceSet = (results.count..<results.count+set.count).map {
            MetaComuteUnitDataSourceSet(id: $0, value: set[results.count + $0])
        }
        resultSemaphore.wait()
        results.append(contentsOf: dataSourceSet)
        resultSemaphore.signal()
    }
    
    func getNextResult() -> MetaComuteUnitDataSourceSet? {
        return getElementFrom(dataSet: .Result, semaphore: resultSemaphore)
    }
    
    
    func storeNextResult(_ result: Any) {
        resultSemaphore.wait()
        results.append(MetaComuteUnitDataSourceSet(id: results.count + 1, value: result))
        resultSemaphore.signal()
    }
    
    /// TODO: statisfy this problem (don't use Protocols and work generic)
    public static func ==(lhs: MetaComputeDataSource, rhs: MetaComputeDataSource) -> Bool{
        return lhs.data.count == rhs.data.count &&
               lhs.results.count == rhs.results.count
    }
}
