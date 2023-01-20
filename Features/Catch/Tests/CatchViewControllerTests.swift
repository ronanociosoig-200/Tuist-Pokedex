//
//  CatchViewControllerTests.swift
//  CatchTests
//
//  Created by Ronan O Ciosoig on 25/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest
import UIKit

@testable import Catch
@testable import Common

final class CatchViewControllerTests: XCTestCase {
    func testViewController() {
        let viewController = CatchWireframe.makeViewController()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        viewController.backgroundImageView = imageView
        viewController.button = button
        
        viewController.viewDidLoad()
        
        XCTAssertNotNil(viewController.backgroundImageView.image)
        XCTAssertNotNil(viewController.button.imageView?.image)
    }
    
    func testViewControllerUpdateWithoutPresenter() {
        let viewController = CatchWireframe.makeViewController()
        
        viewController.update()
        
        XCTAssertNil(viewController.pokemonView)
    }
    
    func testViewControllerUpdate() {
        let viewController = CatchWireframe.makeViewController()
        let presenter = MockCatchPresenter()
        
        viewController.presenter = presenter
        viewController.update()
        
        XCTAssertNotNil(viewController.presenter)
    }
    
    func testViewControllerAlerts() {
        let viewController = CatchWireframe.makeViewController()
        
        let leaveItAlert = viewController.makeLeaveItAlert()
        
        XCTAssertNotNil(leaveItAlert)
        
        let leaveOrCatchAlert = viewController.makeLeaveOrCatchAlert()
        
        XCTAssertNotNil(leaveOrCatchAlert)
        
        let errorAlert = vc.makeErrorAlert(message: "Error")
        
        XCTAssertNotNil(errorAlert)
    }
    
    func testViewControllerBallActionWithoutPresenter() {
        let viewController = CatchWireframe.makeViewController()
        let presenter = MockCatchPresenter()
        
        viewController.ballAction()
        
        XCTAssertFalse(presenter.catchPokemonActionCalled)
    }
    
    func testViewControllerBallActionWithPresenter() {
        let viewController = CatchWireframe.makeViewController()
        let presenter = MockCatchPresenter()
        
        viewController.presenter = presenter
        viewController.ballAction()
        
        XCTAssertTrue(presenter.catchPokemonActionCalled)
    }
}
