//
//  Mocks.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import Foundation

@testable import Common

class MockAppData: AppDataHandling {
    var pokemon: Common.Pokemon?
    var pokemons = [LocalPokemon]()
    
    var newSpeciesCalled = false
    var loadCalled = false
    var saveCalled = false
    var sortByOrderCalled = false
    
    init() {
        
    }
    
    func newSpecies() -> Bool {
        newSpeciesCalled = true
        return true
    }
    
    func load() {
        loadCalled = true
    }
    
    func save() {
        saveCalled = true
    }
    
    func directory() -> Common.Directory {
        return .documents
    }
    
    func sortByOrder() {
        sortByOrderCalled = true
    }
    
    func clean() {
        
    }
}

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
    
    func showCatchScene(identifier: Int?) {
        
    }
    
    func showBackpackScene() {
        
    }
    
    func showPokemonDetailScene(pokemon: Common.LocalPokemon) {
        showPokemonDetailSceneCalled = true
    }
    
    func showAlert(with errorMessage: String) {
        
    }
}
