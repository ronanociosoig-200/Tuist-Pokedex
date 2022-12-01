//
//  DetailViewControllerTests.swift
//  DetailTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Detail

final class DetailViewControllerTests: XCTestCase {
    func testViewWillAppear() {
        let localPokemon = MockPokemonFactory.makeLocalPokemon()
        let viewController = PokemonDetailWireframe.makeViewController()
        
        PokemonDetailWireframe.prepare(viewController,
                                       pokemon: localPokemon)
        
        viewController.viewDidLoad()
        viewController.viewWillAppear(false)
        
        let title = viewController.title
        
        XCTAssertEqual(title, localPokemon.name.capitalized)
    }
}
