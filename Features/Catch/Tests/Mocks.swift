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
        MockPokemonFactory.makeScreenPokemon()
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
        MockPokemonFactory.makeScreenPokemon()
    }
    
    func catchPokemonAction() {
        catchPokemonActionCalled = true
    }
}

let typeElement = TypeElement(slot: 1, type: Species(name: "fire", url: "https://pokeapi.co/api/v2/type/10/"))

class MockCoordinator: Coordinating {
    func showCatchScene(identifier: Int?) {
        
    }
    
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
    
    func showBackpackScene() {
        
    }
    
    func showPokemonDetailScene(pokemon: Common.LocalPokemon) {
        showPokemonDetailSceneCalled = true
    }
    
    func showAlert(with errorMessage: String) {
        
    }
}
