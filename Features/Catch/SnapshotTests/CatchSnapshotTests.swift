//
//  CatchSnapshotTests.swift
//  CatchSnapshotTests
//
//  Created by ronan.ociosoig on 14/05/2023.
//  Copyright © 2023 Sonomos.com. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Catch

final class CatchSnapshotTests: XCTestCase {

    func testCatchViewController() throws {
        let viewController = CatchWireframe.makeViewController()
        
        assertSnapshot(matching: viewController, as: .image)
        assertSnapshot(matching: viewController, as: .recursiveDescription)
    }
}
