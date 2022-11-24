//
//  BackpackDelegateTests.swift
//  PokedexTests
//
//  Created by Ronan O Ciosoig on 22/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest
@testable import Backpack
//@testable import Common

final class BackpackDelegateTests: XCTestCase {
    func testDelegateDidSelectItem() {
        let actions = MockBackpackActions()
        let dataProvider = MockBackpackDataProvider()
        let view = MockBackpackView()
        
        let delegate = BackpackDelegate()
        let mockPresenter = MockBackpackPresenter(actions: actions,
                                                  dataProvider: dataProvider,
                                                  view: view)
        delegate.presenter = mockPresenter
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let indexPath = IndexPath(item: 0, section: 0)
        
        delegate.collectionView(collectionView, didSelectItemAt: indexPath)
        
        XCTAssertTrue(mockPresenter.selectItemCalled, "Did selected should be called")
        
        let result = delegate.collectionView(collectionView, shouldSelectItemAt: indexPath)
        
        XCTAssertTrue(result)
    }
}
