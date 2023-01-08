//
//  HomeSceneUITests.swift
//  HomeUITests
//
//  Created by Ronan on 01/12/2022.
//  Copyright © 2022 Sonomos. All rights reserved.
//

import XCTest

@testable import Home

class HomeSceneUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments += ["UITesting"]
        app.launch()
        
        print(app.debugDescription)
    }
    
    func testHomeScene() {
        
        let app = XCUIApplication()
        app.buttons[HomeSceneIdentifiers.catchButton].tap()
        
        let catchIdentifer = HomeExampleIdentifiers.mockCatchScene
        
        let element = app.otherElements[catchIdentifer].children(matching: .other).element
        element.swipeDown()
        
        app.buttons[HomeSceneIdentifiers.backpackButton].tap()
    }
}

public struct HomeExampleIdentifiers {
    public static let mockCatchScene = "Mock Catch Scene"
    public static let mockBackpackScene = "Mock Backpack Scene"
}
