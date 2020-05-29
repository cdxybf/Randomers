//
//  Environment.swift
//  Randomers
//
//  Created by ChengRosman on 29/05/20.
//  Copyright © 2020 Rosman Cheng. All rights reserved.
//

import Foundation

enum EnvironmentType {
    case Staging
    case Production
}

/// Configure the constants e.g. Url, API Keys, Third-party Keys in this class. It is extendable.
class Environment: NSObject {
    
    static let shared = Environment()
    
    let environmentType: EnvironmentType = .Staging;
    
    var baseUrl: String {
        get {
            if (environmentType == .Staging) {
                return "https://randomuser.me/api/"
            } else if (environmentType == .Production) {
                return "https://randomuser.me/api/"
            } else {
                return ""
            }
        }
    }
}
