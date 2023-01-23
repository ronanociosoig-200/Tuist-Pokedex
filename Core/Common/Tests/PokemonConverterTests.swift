//
//  PokemonConverterTests.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Common

final class PokemonConverterTests: XCTestCase {
    func testConvert() {
        let pokemon = MockPokemonFactory.makePokemon()
        
        let localPokemon = PokemonConverter.convert(pokemon: pokemon)
        
        XCTAssertEqual(pokemon.name, localPokemon.name)
    }
}
