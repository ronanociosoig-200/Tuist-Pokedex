//
//  BackpackSceneUITests.swift
//  BackpackUITests
//
//  Created by Ronan on 01/12/2022.
//  Copyright © 2022 Sonomos. All rights reserved.
//

import XCTest

class BackpackSceneUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments += ["UITesting"]
        app.launch()
        
        print(XCUIApplication().debugDescription)
    }
    
    func testBackpackPokemons() {
        app/*@START_MENU_TOKEN@*/.staticTexts["Backpack"]/*[[".buttons[\"Backpack\"].staticTexts[\"Backpack\"]",".buttons[\"OpenBackpackButton\"].staticTexts[\"Backpack\"]",".staticTexts[\"Backpack\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let pokemonCellsQuery = app.collectionViews.cells.matching(identifier: "Pokemon")
        pokemonCellsQuery.otherElements.containing(.staticText, identifier:"Cascoon").images["Icon"].tap()
        app.navigationBars["Cascoon"].buttons["Backpack"].tap()
        pokemonCellsQuery.otherElements.containing(.staticText, identifier:"Cranidos").images["Icon"].tap()
        app.navigationBars["Cranidos"].buttons["Backpack"].tap()
        app.navigationBars["Backpack"].buttons["Close"].tap()
    }
}
