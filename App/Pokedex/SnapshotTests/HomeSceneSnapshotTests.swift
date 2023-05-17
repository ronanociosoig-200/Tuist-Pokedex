//
//  HomeSceneSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by ronan.ociosoig on 17/05/2023.
//  Copyright © 2023 Sonomos.com. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Pokedex

final class HomeSceneSnapshotTests: XCTestCase {
    let appController = AppController()
    
    override func setUp() {
        UIView.setAnimationsEnabled(false)
        appController.start()
    }
    
    func testShowCatchScene() throws {
        guard let coordinator = appController.coordinator else {
            XCTFail()
            return
        }
        guard let viewController = coordinator.window.rootViewController else {
            XCTFail()
            return
        }
        
        assertSnapshot(matching: viewController, as: .image)
        
        coordinator.showCatchScene(identifier: nil)
        
        let expectation = self.expectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 0.5)

        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testShowBackpackScene() throws {
        guard let coordinator = appController.coordinator else {
            XCTFail()
            return
        }
        guard let viewController = coordinator.window.rootViewController else {
            XCTFail()
            return
        }
        
        assertSnapshot(matching: viewController, as: .image)
        
        coordinator.showBackpackScene()
        
        assertSnapshot(matching: viewController, as: .image)
    }

}
