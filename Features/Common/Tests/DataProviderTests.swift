//
//  DataProviderTests.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Common

final class DataProviderTests: XCTestCase {
    func testStart() {
        let mockAppData = MockAppData()
        let dataProvider = DataProvider()
        
        dataProvider.appData = mockAppData
        
        dataProvider.start()
        
        XCTAssertTrue(mockAppData.loadCalled)
        XCTAssertTrue(mockAppData.sortByOrderCalled)
    }
    
    func testNewSpecies() {
        let mockAppData = MockAppData()
        let dataProvider = DataProvider()
        dataProvider.appData = mockAppData
        
        _ = dataProvider.newSpecies()
        
        XCTAssertTrue(mockAppData.newSpeciesCalled)
    }
    
    func testPokemonAtIndex() {
        let mockAppData = MockAppData()
        let dataProvider = DataProvider()
        let unsortedPokemons = MockPokemonFactory.makeOutOfOrderLocalPokemons()
        
        mockAppData.pokemons.append(contentsOf: unsortedPokemons)
        dataProvider.appData = mockAppData
        
        let selectedPokemon = dataProvider.pokemon(at: 0)
        
        XCTAssertNotNil(selectedPokemon)
    }
    
    func testCatchPokemon() {
        let mockAppData = MockAppData()
        let dataProvider = DataProvider()
        
        mockAppData.pokemon = MockPokemonFactory.makePokemon()
        dataProvider.appData = mockAppData
        dataProvider.catchPokemon()
        
        XCTAssertTrue(mockAppData.sortByOrderCalled)
        XCTAssertTrue(mockAppData.saveCalled)
    }
}
