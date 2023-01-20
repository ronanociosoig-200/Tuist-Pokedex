//
//  BackpackViewControllerTests.swift
//  BackpackTests
//
//  Created by Ronan O Ciosoig on 24/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Backpack

final class BackpackViewControllerTests: XCTestCase {
    func testViewController() {
        let viewController = BackpackWireframe.makeViewController()
        
        let presenter = MockBackpackPresenter(actions: MockBackpackActions(),
                                              dataProvider: MockBackpackDataProvider(),
                                              view: MockBackpackView())
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        viewController.collectionView = collectionView
        viewController.presenter = presenter
        viewController.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerWithoutPresenter() {
        let viewController = BackpackWireframe.makeViewController()
        viewController.viewDidLoad()
        
        XCTAssertNil(viewController.collectionView)
    }
    
    func testViewControllerWithoutCollectionView() {
        let viewController = BackpackWireframe.makeViewController()
        let presenter = MockBackpackPresenter(actions: MockBackpackActions(),
                                              dataProvider: MockBackpackDataProvider(),
                                              view: MockBackpackView())
        viewController.presenter = presenter
        viewController.viewDidLoad()
        
        XCTAssertNil(viewController.collectionView)
    }
    
    func testSetDataSource() {
        let viewController = BackpackWireframe.makeViewController()
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        viewController.collectionView = collectionView
        
        let dataSource = MockBackpackDataSource()
        
        viewController.setDataSource(dataSource: dataSource)
        
        XCTAssertTrue(dataSource.registerCalled)
    }
}
