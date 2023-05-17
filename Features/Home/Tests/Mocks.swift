//
//  Mocks.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import UIKit

@testable import Common
@testable import Home

class MockHomeActions: HomeActions {
    var ballButtonActionCalled = false
    var backpackButtonActionCalled = false
    
    func ballButtonAction() {
        ballButtonActionCalled = true
    }
    
    func backpackButtonAction() {
        backpackButtonActionCalled = true
    }
}

class MockHomeDataProvider: HomeDataProvider {
    
}

class MockHomeView: HomeView {
    
}

class MockHomePresenter: HomePresenting {
    var ballButtonActionCalled = false
    var backpackButtonActionCalled = false
    
    func ballButtonAction() {
        ballButtonActionCalled = true
    }
    
    func backpackButtonAction() {
        backpackButtonActionCalled = true
    }
}

class MockCoordinator: Coordinating {
    var window: UIWindow
    
    var dataProvider: Common.DataProvider?
    
    var showCatchSceneCalled = false
    var showBackpackSceneCalled = false
    
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
        showCatchSceneCalled = true
    }
    
    func showBackpackScene() {
        showBackpackSceneCalled = true
    }
    
    func showPokemonDetailScene(pokemon: Common.LocalPokemon) {
        
    }
    
    func showAlert(with errorMessage: String) {
        
    }
}
