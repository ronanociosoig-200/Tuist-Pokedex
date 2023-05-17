//
//  Mocks.swift
//  Pokedex
//
//  Created by Ronan O Ciosoig on 22/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import UIKit
@testable import Backpack
@testable import Common

class MockBackpackActions: BackpackActions {
    var selectItemCalled = false
    var itemIndex: Int = 0
    
    func selectItem(at index: Int) {
        selectItemCalled = true
        itemIndex = index
    }
}

class MockBackpackDataProvider: BackpackDataProvider {
    func pokemons() -> [Common.LocalPokemon] {
        return MockDataFactory.makePokemons()
    }
}

class MockBackpackView: BackpackView {
    var setDataSourceCalled = false
    
    func setDataSource(dataSource: Backpack.BackpackDataSource) {
        setDataSourceCalled = true
    }
}

struct MockDataFactory {
    static func makePokemons() -> [LocalPokemon] {
        
        let pokemon1 = LocalPokemon(name: "cascoon",
                                    weight: 115,
                                    height: 7,
                                    order: 350,
                                    spriteUrlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/268.png",
                                    date: Date(),
                                    species: "cascoon",
                                    baseExperience: 72,
                                    types: ["bug"])
        let pokemon2 = LocalPokemon(name: "cranidos",
                                    weight: 315,
                                    height: 9,
                                    order: 519,
                                    spriteUrlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/408.png",
                                    date: Date(),
                                    species: "cranidos",
                                    baseExperience: 70,
                                    types: ["rock"])
        
        return [pokemon1, pokemon2]
    }
}

class MockBackpackPresenter: BackpackPresenting {
    var dataSource: Backpack.BackpackDataSource
    var selectItemCalled = false
    var viewDidLoadCalled = false
    
    weak var view: BackpackView?
    var actions: BackpackActions
    var dataProvider: BackpackDataProvider
    
    var delegate: Backpack.BackpackDelegate
    
    init(actions: BackpackActions,
                  dataProvider: BackpackDataProvider,
         view: BackpackView) {
        self.view = view
        self.actions = actions
        self.dataProvider = dataProvider
        
        dataSource = Backpack.BackpackDataSource()
        delegate = Backpack.BackpackDelegate()
        dataSource.presenter = self
        delegate.presenter = self
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func pokemons() -> [Common.LocalPokemon] {
        return MockDataFactory.makePokemons()
    }
    
    func pokemonImagePath(at index: Int) -> String? {
        "sample.png"
    }
    
    func pokemonName(at index: Int) -> String {
        "Pink"
    }
    
    func selectItem(at index: Int) {
        selectItemCalled = true
    }
}

class MockCoordinator: Coordinating {
    var window: UIWindow
    var showPokemonDetailSceneCalled = false
    
    var dataProvider: Common.DataProvider?
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
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

class MockBackpackDataSource: BackpackDataSource {
    var registerCalled = false
    override func register(collectionView: UICollectionView) {
        registerCalled = true
    }
}
