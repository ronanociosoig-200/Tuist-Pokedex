//
//  CatchSceneUITests.swift
//  CatchUITests
//
//  Created by Ronan on 01/12/2022.
//  Copyright © 2022 Sonomos. All rights reserved.
//

import XCTest

@testable import Catch

class CatchSceneUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testCatchPokemon() {
        app.launchArguments += ["CatchUITesting"]
        app.launch()
        
        print(app.debugDescription)
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.catchButton]
        catchStaticText.tap()
        app.alerts[CatchIdentifiers.alertTitle].scrollViews.otherElements.buttons[CatchIdentifiers.catchButton].tap()
    }
    
    func testLeavePokemon() {
        app.launchArguments += ["CatchUITesting"]
        app.launch()
        
        print(app.debugDescription)
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.catchButton]
        catchStaticText.tap()
        app.alerts[CatchIdentifiers.alertTitle].scrollViews.otherElements.buttons[CatchIdentifiers.leaveItButton].tap()
    }
    
    func testError401WhenCatchingPokemon() {
        app.launchArguments += ["Error_401"]
        
        print(app.debugDescription)
        app.launch()
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.catchErrorButton]
        catchStaticText.tap()
        
        app.alerts[CatchIdentifiers.alertError].scrollViews.otherElements.buttons["OK"].tap()
    }
}


struct HomeIdentifiers {
    static let catchButton = "Catch"
    static let catchFixedButton = "Catch Fixed"
    static let catchErrorButton = "Catch Error"
}
