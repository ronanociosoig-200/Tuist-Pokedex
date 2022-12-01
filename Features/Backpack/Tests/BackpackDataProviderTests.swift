//
//  BackpackDataProviderTests.swift
//  BackpackTests
//
//  Created by Ronan O Ciosoig on 23/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Backpack
@testable import Common

final class BackpackDataProviderTests: XCTestCase {
    func testBackpackDataProvider() {
        let dataProvider = DataProvider()
        let mockPokemons = MockBackpackDataProvider().pokemons()
        dataProvider.appData.pokemons = mockPokemons
        
        let pokemons = dataProvider.pokemons()
        
        XCTAssertEqual(pokemons.count, mockPokemons.count)
    }
}
