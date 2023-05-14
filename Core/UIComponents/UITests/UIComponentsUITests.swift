//
//  UIComponentsUITests.swift
//  UIComponents
//
//  Created by Ronan on 25/01/2023.
//  Copyright © 2023 eDreams. All rights reserved.
//

@testable import UIComponents

import XCTest

class UIComponentsUITests: XCTestCase {

    let app = XCUIApplication()
    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments += ["UITesting"]
        app.launch()
        print(app.debugDescription)
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testUIComponents() {
        // Given
        // When
        // Then
    }
}

