//
//  BackpackActionsTests.swift
//  BackpackTests
//
//  Created by Ronan O Ciosoig on 24/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Backpack
@testable import Common

final class BackpackActionsTests: XCTestCase {
    func testAction() {
        let coordinator = MockCoordinator()
        let dataProvider = DataProvider()
        dataProvider.appData.pokemons = MockDataFactory.makePokemons()
        let actions = Actions(coordinator: coordinator)
        actions.dataProvider = dataProvider
        actions.selectItem(at: 0)
        
        XCTAssertTrue(coordinator.showPokemonDetailSceneCalled)
    }
}
