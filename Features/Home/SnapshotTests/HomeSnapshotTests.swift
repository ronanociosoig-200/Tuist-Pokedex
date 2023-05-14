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

    override func setUpWithError() throws {
        
    }

    func testHomeViewController() throws {
        let homeView = HomeWireframe.makeViewController()
        
        assertSnapshot(matching: homeView, as: .image)
        assertSnapshot(matching: homeView, as: .recursiveDescription)
    }
}
