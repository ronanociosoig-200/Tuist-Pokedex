//
//  CatchSceneUITests.swift
//  CatchUITests
//
//  Created by Ronan on 01/12/2022.
//  Copyright © 2022 Sonomos. All rights reserved.
//

import XCTest

@testable import Catch

struct LaunchArguments {
    static let uiTesting = "CatchUITesting"
    static let error401 = "Error_401"
    static let leaveIt = "LeaveIt"
}

class CatchSceneUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testCatchPokemon() {
        app.launchArguments += [LaunchArguments.uiTesting]
        app.launch()
        
        print(app.debugDescription)
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.catchButton]
        catchStaticText.tap()
        app.alerts[CatchIdentifiers.alertTitle].scrollViews.otherElements.buttons[CatchIdentifiers.catchButton].tap()
    }
    
    func testLeavePokemon() {
        app.launchArguments += [LaunchArguments.uiTesting]
        app.launch()
        
        print(app.debugDescription)
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.catchButton]
        catchStaticText.tap()
        app.alerts[CatchIdentifiers.alertTitle].scrollViews.otherElements.buttons[CatchIdentifiers.leaveItButton].tap()
    }
    
    func testError401WhenCatchingPokemon() {
        app.launchArguments += [LaunchArguments.error401]
        
        print(app.debugDescription)
        app.launch()
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.catchErrorButton]
        catchStaticText.tap()
        
        app.alerts[CatchIdentifiers.alertError].scrollViews.otherElements.buttons["OK"].tap()
    }
    
    func testCaseOfPokemonAlreadyCaught() {
        app.launchArguments += [LaunchArguments.leaveIt]
        
        print(app.debugDescription)
        app.launch()
        
        let catchStaticText = app.staticTexts[HomeIdentifiers.leaveItButton]
        catchStaticText.tap()

        app.alerts[CatchIdentifiers.leaveItAlertTitle].scrollViews.otherElements.buttons[CatchIdentifiers.leaveItButton].tap()
    }
}

struct HomeIdentifiers {
    static let catchButton = "Catch"
    static let catchFixedButton = "Catch Fixed"
    static let catchErrorButton = "Catch Error"
    static let leaveItButton = "Leave It"
}
