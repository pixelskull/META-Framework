//
//  File.swift
//  META
//
//  Created by Pascal Schönthier on 31.03.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/**
 protocol for **ComputeDataSource** Implementations. Defines the needed
 variables **data** and **result** as well as the need for semaphores
 
 Also adds some must have funktions like **hasNextElement** and
 **getNextElement** as well as their result counter parts.
 */
protocol ComputeDataSourceable {
    /// stores data objects (MetaComputeDataSet) with **id** for sequential
    /// data usage and **value**.
    var data:[MetaComuteUnitDataSourceSet] { get set }
    // stores the result objects (MetaComputeDataSet) similary to **data**
    var results:[MetaComuteUnitDataSourceSet] { get set }
    
    /// semaphore to protect read and writes from **data** array
    var dataSemaphore:DispatchSemaphore { get set }
    /// semaphore to protect read and writes from **resluts** array
    var resultSemaphore:DispatchSemaphore { get set }
    
    /// initializes an DataSource with given data
    init(data: [MetaComuteUnitDataSourceSet])
    
    /// functions for checking if any data is left in DataSource
    func hasNextElement() -> Bool
    /// gives you the first element of **data**
    func getNextElement() -> MetaComuteUnitDataSourceSet?
    
    /// functions for checking if any result is left in DataSource
    func hashNextResult() -> Bool
    /// gives you the first element of **results**
    func getNextResult() -> MetaComuteUnitDataSourceSet?
    /// function for storing an result in **results**
    func storeNextResult(_ result: Any)
}

/**
 DataSetType for setting **Result** or **Value** of given data.
 */
enum MetaComputeUnitDataSourceDataSetType {
    case Result
    case Data
}

/**
 Wrapper struct for transmitting Data in sequential order.
 This struct provides you with an **id** to sort your results after
 computation.
 */
struct MetaComuteUnitDataSourceSet {
    /// value for sorting purpose
    let id: Int
    /// value to compute
    let value: Any
}

/**
 Default implementation for **ComputeDataSourceable** protocol.
 
 Implements the getter and setter functions for **data** and
 **results** with semaphor safety.
 */
class MetaComputeDataSource: ComputeDataSourceable, Equatable {
    
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
    
    required convenience init(data: [MetaComuteUnitDataSourceSet]) {
        self.init()
        self.data = (0..<data.count).map {
            MetaComuteUnitDataSourceSet(id: $0, value: data[$0])
        }
    }
    
    /**
     Helper getter function to protect getting elements with semaphore protection
     
     - parameter dataSet: set type to perform the getter action
     - parameter semaphore: to protect the dataset
     */
    private func getElementFrom(dataSet: MetaComputeUnitDataSourceDataSetType,
                                semaphore: DispatchSemaphore) -> MetaComuteUnitDataSourceSet? {
        // set semaphore to wait to protect access
        semaphore.wait()
        let result: MetaComuteUnitDataSourceSet?
        switch dataSet {
        case .Result:
            guard !data.isEmpty else { return nil }
            result = results.removeFirst()
        default:
            guard !results.isEmpty else { return nil }
            result = data.removeFirst()
        }
        // free semaphore block
        semaphore.signal()

        return result
    }
    
    
    func hasNextElement() -> Bool {
        return !data.isEmpty
    }
    
    func getNextElement() -> MetaComuteUnitDataSourceSet? {
        return getElementFrom(dataSet: .Data, semaphore: dataSemaphore)
    }
    
    /**
     Helper function for getting more than one data object at a time
     
     - parameter size: size of data set wanted
     */
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
    
    /**
     Helper function for setting more than one value at a time. Also
     wrapps the data into **MetaComuteUnitDataSourceSet**
     
     - parameter set: data to store in results
     */
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
    
    /// function needed to conform to **Equatable** protocol
    public static func ==(lhs: MetaComputeDataSource, rhs: MetaComputeDataSource) -> Bool{
        // TODO: statisfy this problem (don't use Protocols and work generic)
        return lhs.data.count == rhs.data.count &&
               lhs.results.count == rhs.results.count
    }
}
