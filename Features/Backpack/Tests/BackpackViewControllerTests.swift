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
        let vc = BackpackWireframe.makeViewController()
        
        let presenter = MockBackpackPresenter(actions: MockBackpackActions(),
                                              dataProvider: MockBackpackDataProvider(),
                                              view: MockBackpackView())
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.collectionView = collectionView
        vc.presenter = presenter
        vc.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerWithoutPresenter() {
        let vc = BackpackWireframe.makeViewController()
        vc.viewDidLoad()
        
        XCTAssertNil(vc.collectionView)
    }
    
    func testViewControllerWithoutCollectionView() {
        let vc = BackpackWireframe.makeViewController()
        let presenter = MockBackpackPresenter(actions: MockBackpackActions(),
                                              dataProvider: MockBackpackDataProvider(),
                                              view: MockBackpackView())
        vc.presenter = presenter
        vc.viewDidLoad()
        
        XCTAssertNil(vc.collectionView)
    }
    
    func testSetDataSource() {
        let vc = BackpackWireframe.makeViewController()
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.collectionView = collectionView
        
        let dataSource = MockBackpackDataSource()
        
        vc.setDataSource(dataSource: dataSource)
        
        XCTAssertTrue(dataSource.registerCalled)
    }
}
