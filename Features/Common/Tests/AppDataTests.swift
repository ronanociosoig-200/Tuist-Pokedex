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
    
    func testSaveAndLoad() {
        let storage = FileStorage()
        let appData = AppData(storage: storage)
        
        XCTAssertTrue(appData.pokemons.isEmpty)
        appData.pokemons.append(MockPokemonFactory.makeLocalPokemon())
        XCTAssertTrue(appData.pokemons.count == 1)
        appData.save()
        appData.pokemons.removeLast()
        XCTAssertTrue(appData.pokemons.isEmpty)
        appData.load()
        XCTAssertTrue(appData.pokemons.count == 1)
        
        if Storage.fileExists(AppData.pokemonFile, in: .documents) {
            Storage.remove(AppData.pokemonFile, from: .documents)
        }
    }
    
    func testSorting() {
        let expectedName = "cascoon"
        let storage = FileStorage()
        let appData = AppData(storage: storage)
        
        let unsortedPokemons = MockPokemonFactory.makeOutOfOrderLocalPokemons()
        let firstUnsortedPokemon = unsortedPokemons.first
        
        XCTAssertNotEqual(firstUnsortedPokemon?.name, expectedName)
        
        appData.pokemons.append(contentsOf: unsortedPokemons)
        
        appData.sortByOrder()
        
        let firstPokemon = appData.pokemons.first
        
        XCTAssertEqual(firstPokemon?.name, expectedName)
    }
}
