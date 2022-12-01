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
        let vc = PokemonDetailWireframe.makeViewController()
        
        XCTAssertNotNil(vc)
    }
    
    func testPrepare() {
        let vc = PokemonDetailWireframe.makeViewController()
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        PokemonDetailWireframe.prepare(vc, pokemon: localPokemon)
        
        XCTAssertNotNil(vc.presenter)
    }
}
