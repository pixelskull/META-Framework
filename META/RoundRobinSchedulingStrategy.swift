//
//  RoundRobinSchedulingStrategy.swift
//  META
//
//  Created by Pascal Schönthier on 08.08.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

class RoundRobinSchedulingStrategy: SchedulingStrategy {
    
    let dataSource: MetaComputeDataSource!
    let computeUnit: ComputeUnit!
    
    let url: URL!
    
    private var operate: Bool = false
    
    init(withDataSource dataSource: MetaComputeDataSource,
         basedOn computeUnit: ComputeUnit,
         backendURL:String = "localhost") {
        self.dataSource = dataSource
        self.computeUnit = computeUnit
        
        url = URL(string: backendURL)
    }
    
    private func postRequest(url: URL, data: Data) {
        //TODO: add key
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
            postRequest(url: url, data: NSKeyedArchiver.archivedData(withRootObject: remoteData))
            // compute values locally
            localData.forEach { (dataSourceSet) in
                let resultValue = self.computeUnit.compute(data: dataSourceSet.value)
                self.dataSource.storeNextResult(resultValue)
            }
        }
    }
    
    func stop() {
        operate = false
    }
    
    
}
