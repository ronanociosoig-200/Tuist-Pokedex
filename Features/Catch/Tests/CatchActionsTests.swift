//
//  CatchActionsTests.swift
//  CatchTests
//
//  Created by Ronan O Ciosoig on 25/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Catch
@testable import Common

final class CatchActionsTests: XCTestCase {
    func testActions() {
        let pokemon = MockDataFactory.makePokemon()
        let actions = Actions(coordinator: MockCoordinator())
        let dataProvider = DataProvider()
        actions.dataProvider = dataProvider
        dataProvider.appData.pokemon = pokemon
        XCTAssertTrue(dataProvider.appData.pokemons.count == 0)
        actions.catchPokemon()
        XCTAssertTrue(dataProvider.appData.pokemons.count == 1)
    }
}
