//
//  HomeSceneSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by ronan.ociosoig on 17/05/2023.
//  Copyright © 2023 Sonomos.com. All rights reserved.
//

import XCTest
import SnapshotTesting
import NetworkKit
import Common
@testable import Pokedex

// This is supposed to be a fix for Snapshot testing modal screens but it isn't working.
// Snapshots work fine for push screen transitions.
// https://github.com/pointfreeco/swift-snapshot-testing/issues/279
extension Snapshotting where Value: UIViewController, Format == UIImage {
    static var windowedImage: Snapshotting {
        return Snapshotting<UIImage, UIImage>.image.asyncPullback { vc in
            Async<UIImage> { callback in
                UIView.setAnimationsEnabled(false)
                let window = UIApplication.shared.windows[0]
                window.rootViewController = vc
                DispatchQueue.main.async {
                    let image = UIGraphicsImageRenderer(bounds: window.bounds).image { ctx in
                        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                    }
                    callback(image)
                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
}

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
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13))

        coordinator.showCatchScene(identifier: 101)
        
        let expectation = self.expectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 1.0)

        // This isn't a fix
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13))
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
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13))
        
        coordinator.showBackpackScene()
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13))
    }
}
