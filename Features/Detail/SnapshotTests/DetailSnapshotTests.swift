//
//  DetailSnapshotTests.swift
//  DetailSnapshotTests
//
//  Created by ronan.ociosoig on 14/05/2023.
//  Copyright © 2023 Sonomos.com. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Detail

final class DetailSnapshotTests: XCTestCase {

    func testDetailViewController() throws {
        let viewController = PokemonDetailWireframe.makeViewController()
        
        assertSnapshot(matching: viewController, as: .image)
        assertSnapshot(matching: viewController, as: .recursiveDescription)
    }
}
