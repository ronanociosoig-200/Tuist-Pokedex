//
//  Mocks.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import Foundation

@testable import Common

class MockFileStorage: Storable {
    func fileExists(fileName: String, in directory: Common.Directory) -> Bool {
        <#code#>
    }
    
    func save<T>(_ object: T, to directory: Common.Directory, as fileName: String) where T : Encodable {
        <#code#>
    }
    
    func load<T>(_ fileName: String, from directory: Common.Directory, as type: T.Type) -> T? where T : Decodable {
        <#code#>
    }
    
    func remove(_ fileName: String, from directory: Common.Directory) {
        <#code#>
    }
}
