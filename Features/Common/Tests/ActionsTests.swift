//
//  ActionsTests.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Common

final class ActionsTests: XCTestCase {
    func testActions() {
        let coordinator = MockCoordinator()
        let actions = Actions(coordinator: coordinator)
        
        XCTAssertNotNil(actions)
    }
}
