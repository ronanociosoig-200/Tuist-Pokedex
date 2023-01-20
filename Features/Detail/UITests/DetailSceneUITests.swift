//
//  DetailSceneUITests.swift
//  DetailUITests
//
//  Created by Ronan on 01/12/2022.
//  Copyright © 2022 Sonomos. All rights reserved.
//

import XCTest
import Common
@testable import Detail

class DetailSceneUITests: XCTestCase {

    let app = XCUIApplication()
    let pokemon = MockDataFactory.makePokemon()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments += ["UITesting"]
        app.launch()
        
        print(XCUIApplication().debugDescription)
    }
    
    func testPokemonDetails() {
        let heightLabel = app.staticTexts[Common.PokemonViewIdentifiers.height]
        XCTAssertTrue(heightLabel.isHittable)
        let weightLabel = app.staticTexts[Common.PokemonViewIdentifiers.weight]
        XCTAssertTrue(weightLabel.isHittable)
        let dateLabel = app.staticTexts[Common.PokemonViewIdentifiers.date]
        XCTAssertTrue(dateLabel.isHittable)
        let typesLabel = app.staticTexts[Common.PokemonViewIdentifiers.types]
        XCTAssertTrue(typesLabel.isHittable)
        let experienceLabel = app.staticTexts[Common.PokemonViewIdentifiers.experience]
        XCTAssertTrue(experienceLabel.isHittable)
        let imageView = app.images[Common.PokemonViewIdentifiers.imageView]
        XCTAssertTrue(imageView.isHittable)
        
        let navigationBar = app.navigationBars.firstMatch
        let title = navigationBar.staticTexts[pokemon.name.capitalized]
        XCTAssertNotNil(title)
    }
}

struct MockDataFactory {
    static func makePokemon() -> LocalPokemon {
        LocalPokemon(name: "cascoon",
                     weight: 115,
                     height: 7,
                     order: 350,
                     spriteUrlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/268.png",
                     date: Date(),
                     species: "cascoon",
                     baseExperience: 72,
                     types: ["bug"])
    }
}
