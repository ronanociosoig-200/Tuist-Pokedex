//
//  CatchDataProviderTests.swift
//  CatchTests
//
//  Created by Ronan O Ciosoig on 25/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Catch
@testable import Common

final class CatchDataProviderTests: XCTestCase {
    func testDataProviderPokemon() {
        let pokemon = MockPokemonFactory.makePokemon()
        let dataProvider = DataProvider()
        dataProvider.appData.pokemon = pokemon
        let screenPokemon = dataProvider.pokemon()
        
        XCTAssertNotNil(screenPokemon)
    }
}
