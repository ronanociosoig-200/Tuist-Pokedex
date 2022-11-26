//
//  HomeWireframeTests.swift
//  HanekeTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Home

final class HomeWireframeTests: XCTestCase {
    func testHomeViewController() {
        let viewController = HomeWireframe.makeViewController()
        
        HomeWireframe.prepare(viewController,
                              actions: MockHomeActions(),
                              dataProvider: MockHomeDataProvider())
        
        XCTAssertNotNil(viewController.presenter)
    }
}
