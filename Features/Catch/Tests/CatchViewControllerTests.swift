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
        let vc = CatchWireframe.makeViewController()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        vc.backgroundImageView = imageView
        vc.button = button
        
        vc.viewDidLoad()
        
        XCTAssertNotNil(vc.backgroundImageView.image)
        XCTAssertNotNil(vc.button.imageView?.image)
    }
    
    func testViewControllerUpdateWithoutPresenter() {
        let vc = CatchWireframe.makeViewController()
        
        vc.update()
        
        XCTAssertNil(vc.pokemonView)
    }
    
    func testViewControllerUpdate() {
        let vc = CatchWireframe.makeViewController()
        let presenter = MockCatchPresenter()
        
        vc.presenter = presenter
        vc.update()
        
        XCTAssertNotNil(vc.presenter)
    }
    
    func testViewControllerAlerts() {
        let vc = CatchWireframe.makeViewController()
        
        let leaveItAlert = vc.makeLeaveItAlert()
        
        XCTAssertNotNil(leaveItAlert)
        
        let leaveOrCatchAlert = vc.makeLeaveOrCatchAlert()
        
        XCTAssertNotNil(leaveOrCatchAlert)
        
        let errorAlert = vc.makeErrorAlert(message: "Error")
        
        XCTAssertNotNil(errorAlert)
    }
    
    func testViewControllerBallActionWithoutPresenter() {
        let vc = CatchWireframe.makeViewController()
        let presenter = MockCatchPresenter()
        
        vc.ballAction()
        
        XCTAssertFalse(presenter.catchPokemonActionCalled)
    }
    
    func testViewControllerBallActionWithPresenter() {
        let vc = CatchWireframe.makeViewController()
        let presenter = MockCatchPresenter()
        
        vc.presenter = presenter
        vc.ballAction()
        
        XCTAssertTrue(presenter.catchPokemonActionCalled)
    }
}
