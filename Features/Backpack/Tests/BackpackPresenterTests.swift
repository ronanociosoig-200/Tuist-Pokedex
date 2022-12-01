//
//  BackpackPresenterTests.swift
//  PokedexTests
//
//  Created by Ronan O Ciosoig on 22/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest
@testable import Backpack
@testable import Common

final class BackpackPresenterTests: XCTestCase {

    func testPresneterActionCalled() {
        let expectedIndex: Int = 2
        let actions = MockBackpackActions()
        let presenter = BackpackPresenter(actions: actions,
                                          dataProvider: MockBackpackDataProvider(),
                                          view: MockBackpackView())
        
        presenter.selectItem(at: expectedIndex)
        
        XCTAssertTrue(actions.selectItemCalled, "Function selectItem should be called")
        XCTAssertEqual(expectedIndex, actions.itemIndex, "Selected index shold be the same")
    }
    
    func testPresenterRetunsPokemons() {
        let dataProvider = MockBackpackDataProvider()
        let expectedPokemons = dataProvider.pokemons()
        let presenter = BackpackPresenter(actions: MockBackpackActions(),
                                          dataProvider: dataProvider,
                                          view: MockBackpackView())
        
        let pokemons = presenter.pokemons()
        XCTAssertEqual(expectedPokemons.count, pokemons.count)
    }
    
    func testPresenterViewDidLoad() {
        let view = MockBackpackView()
        let presenter = BackpackPresenter(actions: MockBackpackActions(),
                                          dataProvider: MockBackpackDataProvider(),
                                          view: view)
        presenter.viewDidLoad()
        
        XCTAssertTrue(view.setDataSourceCalled)
    }
}

