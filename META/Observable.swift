//
//  Observable.swift
//  META
//
//  Created by Pascal Schönthier on 30.05.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation

/// protocol for observable pattern implementation
protocol Observable {
    
    func willChange(propertyName: String, newPropertyValue value: Any?)
    func didChange(propertyName: String, oldPropertyValue value: Any?)
    
}

/// Default implementation for using Observable
class DefaultObserver: Observable {
    /// updates subscribers with information that changes will appear
    func willChange(propertyName: String, newPropertyValue value: Any?) {
        if value != nil {
            let notificationName = NSNotification.Name(rawValue: propertyName)
            NotificationCenter.default.post(name: notificationName, object: value)
        }
    }
    
    /// updates subscribers with information that changes did appear
    func didChange(propertyName: String, oldPropertyValue value: Any?) {
        if value != nil {
            let notificationName = NSNotification.Name(rawValue: propertyName)
            NotificationCenter.default.post(name: notificationName, object: value)
        }
    }
    
}
