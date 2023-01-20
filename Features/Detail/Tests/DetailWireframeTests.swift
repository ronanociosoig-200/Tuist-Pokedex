//
//  DetailWireframeTests.swift
//  DetailTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Detail

final class DetailWireframeTests: XCTestCase {
    func testViewController() {
        let viewController = PokemonDetailWireframe.makeViewController()
        
        XCTAssertNotNil(viewController)
    }
    
    func testPrepare() {
        let viewController = PokemonDetailWireframe.makeViewController()
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        PokemonDetailWireframe.prepare(viewController, pokemon: localPokemon)
        
        XCTAssertNotNil(viewController.presenter)
    }
}
