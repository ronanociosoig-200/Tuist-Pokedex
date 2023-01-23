//
//  Configuration.swift
//  Network
//
//  Created by Ronan on 09/02/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import UIKit

struct NetworkTestCase {
    static let uiTesting = "UITesting"
    static let networkingTesting = "NetworkTesting"
    static let searchError = "Error_401"
}

struct Configuration {
    
    static var uiTesting: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains(NetworkTestCase.uiTesting)
    }
    
    static var networkTesting: Bool {
        return CommandLine.arguments.contains(NetworkTestCase.networkingTesting)
    }
    
    static var searchErrorTesting: Bool {
        return CommandLine.arguments.contains(NetworkTestCase.searchError)
    }
}
