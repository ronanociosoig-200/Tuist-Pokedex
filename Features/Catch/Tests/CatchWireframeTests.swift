//
//  CatchWireframeTests.swift
//  CatchTests
//
//  Created by Ronan O Ciosoig on 24/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Catch

final class CatchWireframeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewControllerHasInjectedStructure() {
        let viewController = CatchWireframe.makeViewController()
        
        XCTAssertNotNil(viewController, "ViewController should not be nil")
        
        CatchWireframe.prepare(viewController, actions: MockCatchActions(), dataProvider: MockCatchDataProvider())
        
        let presenter = viewController.presenter
        
        XCTAssertNotNil(presenter, "Presenter must not be nil")
    }
}
