//
//  HomeActions.swift
//  Pokedex
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Common

private struct Dummy {
    static let value = 100
}

public protocol HomeActions {
    func ballButtonAction()
    func backpackButtonAction()
}

extension Actions: HomeActions {
    public func ballButtonAction() {
        coordinator.showCatchScene(identifier: nil)
    }
    
    public func backpackButtonAction() {
        coordinator.showBackpackScene()
    }
}
