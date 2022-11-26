//
//  HomeViewControllerTests.swift
//  HomeTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Home

final class HomeViewControllerTests: XCTestCase {
    func testBallButtonAction() {
        // Given
        let viewController = HomeWireframe.makeViewController()
        let presenter = MockHomePresenter()
        viewController.presenter = presenter
        
        // When
        viewController.ballButtonAction()
        
        // Then
        XCTAssertTrue(presenter.ballButtonActionCalled)
    }
    
    func testBackpackButtonAction() {
        // Given
        let viewController = HomeWireframe.makeViewController()
        let presenter = MockHomePresenter()
        viewController.presenter = presenter
        
        // When
        viewController.backpackButtonAction()
        
        // Then
        XCTAssertTrue(presenter.backpackButtonActionCalled)
    }
}
