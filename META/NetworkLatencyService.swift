//
//  NetworkLatencyService.swift
//  META
//
//  Created by Pascal Schönthier on 12.04.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLatencyService {
    class func getLatency(to domain:String, withHandler handler: @escaping (TimeInterval) -> Void) {
        Alamofire.request(domain).response { response in
            print("latency: \(response.timeline.latency)")
            handler(response.timeline.latency)
        }
    }
}

