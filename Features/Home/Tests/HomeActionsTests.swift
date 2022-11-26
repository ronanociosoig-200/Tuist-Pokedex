//
//  HomeActionsTests.swift
//  HomeTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Common
@testable import Home

final class HomeActionsTests: XCTestCase {
    func testBallButtonAction() {
        let coordinator = MockCoordinator()
        let actions = Actions(coordinator: coordinator)
        
        actions.ballButtonAction()
        
        XCTAssertTrue(coordinator.showCatchSceneCalled)
    }
    
    func testBackpackButtonAction() {
        let coordinator = MockCoordinator()
        let actions = Actions(coordinator: coordinator)
        
        actions.backpackButtonAction()
        
        XCTAssertTrue(coordinator.showBackpackSceneCalled)
    }
}
