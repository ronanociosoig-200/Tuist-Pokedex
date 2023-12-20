//
//  DetailPresenterTests.swift
//  DetailTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Common
@testable import Detail

final class DetailPresenterTests: XCTestCase {
    func testInit() {
        let presenter = PokemonDetailPresenter(pokemon: MockPokemonFactory.makeLocalPokemon())
        
        XCTAssertNotNil(presenter)
    }
    
    func testWeight() {
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        let expectedWeight = "\(Constants.Translations.DetailScene.weight): \(localPokemon.weight)"
        let presenter = PokemonDetailPresenter(pokemon: localPokemon)
        
        XCTAssertEqual(presenter.weight(), expectedWeight)
    }
    
    func testHeight() {
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        let expectedHeight = "\(Constants.Translations.DetailScene.height): \(localPokemon.height)"
        let presenter = PokemonDetailPresenter(pokemon: localPokemon)
        
        XCTAssertEqual(presenter.height(), expectedHeight)
    }
    
    func testName() {
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        let expectedName = localPokemon.name
        let presenter = PokemonDetailPresenter(pokemon: localPokemon)
        
        XCTAssertEqual(presenter.name(), expectedName)
    }
    
    func testImagePath() {
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        let expectedImagePath = localPokemon.spriteUrlString
        let presenter = PokemonDetailPresenter(pokemon: localPokemon)
        
        XCTAssertEqual(presenter.imagePath(), expectedImagePath)
    }
    
    func testDate() {
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        let presenter = PokemonDetailPresenter(pokemon: localPokemon)
        let expectedDate = presenter.formatter.string(from: localPokemon.date)
        XCTAssertEqual(presenter.date(), expectedDate)
    }
}

class MockDetailView: PokemonDetailView {
    
}
