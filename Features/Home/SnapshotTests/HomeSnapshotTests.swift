//
//  HomeSnapshotTests.swift
//  HomeSnapshotTests
//
//  Created by ronan.ociosoig on 14/05/2023.
//  Copyright © 2023 Sonomos.com. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Home

final class HomeSnapshotTests: XCTestCase {
    
    func testHomeViewController() throws {
        let viewController = HomeWireframe.makeViewController()
        
        assertSnapshot(matching: viewController, as: .image)
        assertSnapshot(matching: viewController, as: .recursiveDescription)
    }
}
