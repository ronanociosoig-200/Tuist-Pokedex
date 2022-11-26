//
//  AppDataTests.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Common

final class AppDataTests: XCTestCase {
    func testNewSpeciesIsFalseWhenNoPokemonDefined() {
        let storage = FileStorage()
        let appData = AppData(storage: storage)
        
        XCTAssertFalse(appData.newSpecies())
    }
    
    func testNewSpeciesIsTrueWhenPokemonDefinedButNoOthers() {
        let storage = FileStorage()
        let appData = AppData(storage: storage)
        appData.pokemon = MockPokemonFactory.makePokemon()
        
        XCTAssertTrue(appData.newSpecies())
    }
    
    func testNewSpeciesIsFalseWhenPokemonsAreEqual() {
        let storage = FileStorage()
        let appData = AppData(storage: storage)
        appData.pokemon = MockPokemonFactory.makePokemon()
        appData.pokemons.append(MockPokemonFactory.makeLocalPokemon())
        
        XCTAssertFalse(appData.newSpecies())
    }
    
    func testAppDataSave() {
        
    }
    
    func testAppDataLoad() {
        
    }
}
