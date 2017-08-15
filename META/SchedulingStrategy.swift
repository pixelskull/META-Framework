//
//  SchedulingStrategie.swift
//  META
//
//  Created by Pascal Schönthier on 03.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/**
 protocol to define new ways of interacting with the scheduling.
 this little protocol lets you implement your own scheduling
 method to make META behave like you want
 */
protocol SchedulingStrategy {
    /// starts computation and distributes data to host
    func schedule()
    /// stops computation and scheduling 
    mutating func stop()
}
