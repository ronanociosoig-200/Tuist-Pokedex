import Foundation
import XCTest
@testable import Backpack
@testable import Common

final class BackpackTests: XCTestCase {
    func testViewControllerHasInjectedStructure() {
        let vc = BackpackWireframe.makeViewController()
        
        XCTAssertNotNil(vc, "ViewController should not be nil")
        
        BackpackWireframe.prepare(vc, actions: MockActions(), dataProvider: MockDataProvider())
        
        let presenter = vc.presenter
        
        XCTAssertNotNil(presenter, "Presenter must not be nil")
        
        XCTAssertNotNil(presenter?.delegate, "Presenter delegate must not be nil")
        
        XCTAssertNotNil(presenter?.dataSource, "Presenter data source must not be nil")
    }
    
    func testNavigationControllerNotNil() {
        let navController = BackpackWireframe.makeNavigationController()
        
        XCTAssertNotNil(navController, "NavigationController should not be nil")
    }
}

struct MockActions: BackpackActions {
    func selectItem(at index: Int) {
        
    }
}

struct MockDataProvider: BackpackDataProvider {
    func pokemons() -> [Common.LocalPokemon] {
        return []
    }
}
