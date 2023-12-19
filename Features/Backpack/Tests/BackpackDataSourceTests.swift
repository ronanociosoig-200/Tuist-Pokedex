//
//  BackpackDataSourceTests.swift
//  BackpackTests
//
//  Created by Ronan O Ciosoig on 24/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//
// swiftlint:disable force_unwrapping force_cast

import XCTest

@testable import Backpack

final class BackpackDataSourceTests: XCTestCase {
    func testBackpackDataSourceNumberOfItems() {
        let dataProvider = MockBackpackDataProvider()
        let presenter = BackpackPresenter(actions: MockBackpackActions(),
                                          dataProvider: dataProvider,
                                          view: MockBackpackView())
        
        let dataSource = BackpackDataSource()
        dataSource.presenter = presenter
        
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource.register(collectionView: collectionView)
        let numberOfItems = dataSource.collectionView(collectionView,
                                                      numberOfItemsInSection: 0)
        
        XCTAssertEqual(dataProvider.pokemons().count, numberOfItems)
    }
    
    func testBackpackDataSourceCellForItemAtIndexPath() {
        let dataProvider = MockBackpackDataProvider()
        let firstPokemon = dataProvider.pokemons().first
        let presenter = BackpackPresenter(actions: MockBackpackActions(),
                                          dataProvider: dataProvider,
                                          view: MockBackpackView())
        
        let dataSource = BackpackDataSource()
        dataSource.presenter = presenter
        let indexPath = IndexPath(item: 0, section: 0)
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource.register(collectionView: collectionView)
        
        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as! PokemonCollectionViewCell
        let expectedName = firstPokemon!.name
        let cellName = cell.name.text?.lowercased()
        XCTAssertEqual(cellName, expectedName)
    }
    
    func testBackpackDataSourceReturnsCellIfPresenterNotDefined() {
        let dataSource = BackpackDataSource()
        let indexPath = IndexPath(item: 0, section: 0)
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource.register(collectionView: collectionView)
        
        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testNumberOfItemsIsZeroIfPresenterNotDefined() {
        let dataSource = BackpackDataSource()
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource.register(collectionView: collectionView)
        let numberOfItems = dataSource.collectionView(collectionView,
                                                      numberOfItemsInSection: 0)
        
        XCTAssertEqual(0, numberOfItems)
    }
    
    func testBackpackDataSourceCellWithoutImageURL() {
        let dataProvider = MockBackpackDataProviderWithoutImageURL()
        let firstPokemon = dataProvider.pokemons().first
        let presenter = BackpackPresenter(actions: MockBackpackActions(),
                                          dataProvider: dataProvider,
                                          view: MockBackpackView())
        
        let dataSource = BackpackDataSource()
        dataSource.presenter = presenter
        let indexPath = IndexPath(item: 0, section: 0)
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource.register(collectionView: collectionView)
        
        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as! PokemonCollectionViewCell
        let expectedName = firstPokemon!.name
        let cellName = cell.name.text?.lowercased()
        XCTAssertEqual(cellName, expectedName)
    }
    
    func testBackpackDataSourceCellWithInvalidImageURL() {
        let dataProvider = MockBackpackDataProviderWithInvalidImageURL()
        let firstPokemon = dataProvider.pokemons().first
        let presenter = BackpackPresenter(actions: MockBackpackActions(),
                                          dataProvider: dataProvider,
                                          view: MockBackpackView())
        
        let dataSource = BackpackDataSource()
        dataSource.presenter = presenter
        let indexPath = IndexPath(item: 0, section: 0)
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource.register(collectionView: collectionView)
        
        let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as! PokemonCollectionViewCell
        let expectedName = firstPokemon!.name
        let cellName = cell.name.text?.lowercased()
        XCTAssertEqual(cellName, expectedName)
    }
}
