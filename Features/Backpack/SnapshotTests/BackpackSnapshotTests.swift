//
//  BackpackSnapshotTests.swift
//  BackpackSnapshotTests
//
//  Created by ronan.ociosoig on 14/05/2023.
//  Copyright © 2023 Sonomos.com. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Backpack

final class BackpackSnapshotTests: XCTestCase {

    func testBackpackViewController() throws {
        let viewController = BackpackWireframe.makeViewController()
        
        assertSnapshot(matching: viewController, as: .image)
        assertSnapshot(matching: viewController, as: .recursiveDescription)
    }
}
