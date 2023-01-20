import Foundation
import XCTest

@testable import Backpack
@testable import Common

final class BackpackWireframeTests: XCTestCase {
    func testViewControllerHasInjectedStructure() {
        let viewController = BackpackWireframe.makeViewController()
        
        XCTAssertNotNil(viewController, "ViewController should not be nil")
        
        BackpackWireframe.prepare(viewController, actions: MockBackpackActions(), dataProvider: MockBackpackDataProvider())
        
        let presenter = viewController.presenter
        
        XCTAssertNotNil(presenter, "Presenter must not be nil")
        
        XCTAssertNotNil(presenter?.delegate, "Presenter delegate must not be nil")
        
        XCTAssertNotNil(presenter?.dataSource, "Presenter data source must not be nil")
    }
    
    func testNavigationControllerNotNil() {
        let navController = BackpackWireframe.makeNavigationController()
        
        XCTAssertNotNil(navController, "NavigationController should not be nil")
    }
}
