//
//  RoundRobinSchedulingStrategy.swift
//  META
//
//  Created by Pascal Schönthier on 08.08.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/**
 Basic scheduling implementation. This one tries to dirstribute
 to mobile and remode evenly.
 */
class RoundRobinSchedulingStrategy: SchedulingStrategy {
    /// datasource with the data to compute
    let dataSource: MetaComputeDataSource!
    /// ComputeUnit to compute the data out of **dataSource**
    let computeUnit: ComputeUnit!
    /// property for stroring host url
    let url: URL!
    /// private variable to stop scheduling
    private var operate: Bool = false
    
    init(withDataSource dataSource: MetaComputeDataSource,
         basedOn computeUnit: ComputeUnit,
         backendURL:String = "localhost") {
        self.dataSource = dataSource
        self.computeUnit = computeUnit
        
        url = URL(string: backendURL)
    }
    
    /**
     Helper function to handle url requests and response. Creates an URLRequest and
     sets an callback closure.
     
     - parameter url: host url to perform request
     - parameter data: data to send to remote ComputeUnit
     */
    private func postRequest(url: URL, data: Data) {
        let apiKey: String = ""
        let jsonDict = ["id": apiKey, "data": data] as [String : Any]
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/json: charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { (json, response, error) in
                guard let json = json else { return }
                do {
                    let decoded = try JSONSerialization.jsonObject(with: json, options: [])
                    let dictFromJSON = decoded as? [String:Any]
                    
                    self.dataSource.appendSetofResults((dictFromJSON!["data"] as? [Any])!)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func schedule() {
        operate = true
        let chunkSize = 10
        
        while operate {
            if !dataSource.hasNextElement() {
                operate = false
                break
            }
            let localData = dataSource.getSetOfElements(size: chunkSize)
            let remoteData = dataSource.getSetOfElements(size: chunkSize)
            
            // send data to host
            do {
                postRequest(url: url, data: try NSKeyedArchiver.archivedData(withRootObject: remoteData, requiringSecureCoding: false))
                // compute values locally
                localData.forEach { (dataSourceSet) in
                    let resultValue = self.computeUnit.compute(data: dataSourceSet.value)
                    self.dataSource.storeNextResult(resultValue)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func stop() {
        operate = false
    }
    
    
}
