//
//  Mocks.swift
//  CatchTests
//
//  Created by Ronan O Ciosoig on 24/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import UIKit

@testable import Catch
@testable import Common

class MockCatchView: CatchView {
    var updateCalled = false
    var showLeaveOrCatchAlertCalled = false
    var showLeaveItAlertCalled = false
    var showNotFoundAlertCalled = false
    var showErrorCalled = false
    
    func update() {
        updateCalled = true
    }
    
    func showLeaveOrCatchAlert() {
        showLeaveOrCatchAlertCalled = true
    }
    
    func showLeaveItAlert() {
        showLeaveItAlertCalled = true
    }
    
    func showNotFoundAlert() {
        showNotFoundAlertCalled = true
    }
    
    func showError(message: String) {
        showErrorCalled = true
    }
}

class MockCatchActions: CatchActions {
    var catchCalled = false
    
    func catchPokemon() {
        catchCalled = true
    }
}

class MockCatchDataProvider: CatchDataProvider {
    func pokemon() -> Common.ScreenPokemon? {
        MockDataFactory.makeScreenPokemon()
    }
    
    func newSpecies() -> Bool {
        true
    }
}

class MockEmptyCatchDataProvider: CatchDataProvider {
    func pokemon() -> Common.ScreenPokemon? {
        return nil
    }
    
    func newSpecies() -> Bool {
        false
    }
}

class MockCatchPresenter: CatchPresenting {
    var catchPokemonActionCalled = false
    func pokemon() -> Common.ScreenPokemon? {
        MockDataFactory.makeScreenPokemon()
    }
    
    func catchPokemonAction() {
        catchPokemonActionCalled = true
    }
}

struct MockDataFactory {
    static func makeScreenPokemon() -> ScreenPokemon {
        ScreenPokemon(name: "cascoon",
                             weight: 115,
                             height: 7,
                             iconPath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/5.png")
    }
    
    static func makeLocalPokemon() -> LocalPokemon {
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
    
    static func makePokemon() -> Pokemon {
        Pokemon(baseExperience: 100,
                height: 7,
                id: 420,
                name: "cascoon",
                order: 1,
                species: Species(name: "cascoon", url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/268.png"),
                sprites: Sprites(backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/5.png",
                                 backFemale: nil,
                                 backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/5.png",
                                 backShinyFemale: nil,
                                 frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/5.png",
                                 frontFemale: nil,
                                 frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/5.png",
                                 frontShinyFemale: nil),
                types: [typeElement],
                weight: 115)
    }
}

let typeElement = TypeElement(slot: 1, type: Species(name: "fire", url: "https://pokeapi.co/api/v2/type/10/"))

class MockCoordinator: Coordinating {
    var showPokemonDetailSceneCalled = false
    
    var dataProvider: Common.DataProvider?
    
    func start() {
        
    }
    
    func showLoading() {
        
    }
    
    func dismissLoading() {
        
    }
    
    func showHomeScene() {
        
    }
    
    func showCatchScene() {
        
    }
    
    func showBackpackScene() {
        
    }
    
    func showPokemonDetailScene(pokemon: Common.LocalPokemon) {
        showPokemonDetailSceneCalled = true
    }
    
    func showAlert(with errorMessage: String) {
        
    }
}
