//
//  HomePresenterTests.swift
//  HomeTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Home

final class HomePresenterTests: XCTestCase {
    func testPresenter() {
        let view = MockHomeView()
        let actions = MockHomeActions()
        let dataProvider = MockHomeDataProvider()
        let presenter = HomePresenter(view: view,
                                      actions: actions,
                                      dataProvider: dataProvider)
        
        XCTAssertNotNil(presenter)
        
        presenter.ballButtonAction()
        
        XCTAssertTrue(actions.ballButtonActionCalled)
        
        presenter.backpackButtonAction()
        
        XCTAssertTrue(actions.backpackButtonActionCalled)
    }
}
