//
//  CatchPresenterTests.swift
//  CatchTests
//
//  Created by Ronan O Ciosoig on 25/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import XCTest

@testable import Catch

final class CatchPresenterTests: XCTestCase {
    func testPresenterUpdateWithoutView() {
        let presenter = CatchPresenter(view: nil,
                                       actions: MockCatchActions(),
                                       dataProvider: MockEmptyCatchDataProvider())
        presenter.update()
        
        XCTAssertNotNil(presenter)
    }
    
    func testPresenterUpdateWithoutPokemon() {
        let view = MockCatchView()
        let presenter = CatchPresenter(view: view,
                                       actions: MockCatchActions(),
                                       dataProvider: MockEmptyCatchDataProvider())
        presenter.update()
        
        XCTAssertTrue(view.updateCalled)
        XCTAssertTrue(view.showNotFoundAlertCalled)
    }
    
    func testPresenterUpdateWithPokemon() {
        let view = MockCatchView()
        let presenter = CatchPresenter(view: view,
                                       actions: MockCatchActions(),
                                       dataProvider: MockCatchDataProvider())
        presenter.update()
        
        XCTAssertTrue(view.updateCalled)
        XCTAssertFalse(view.showNotFoundAlertCalled)
        XCTAssertTrue(view.showLeaveOrCatchAlertCalled)
    }
    
    func testPresenterShowError() {
        let view = MockCatchView()
        let actions = MockCatchActions()
        let presenter = CatchPresenter(view: view,
                                       actions: actions,
                                       dataProvider: MockEmptyCatchDataProvider())
        
        presenter.showError(message: "Some error")
        XCTAssertTrue(view.showErrorCalled)
    }
    
    func testPresenterActions() {
        let view = MockCatchView()
        let actions = MockCatchActions()
        let presenter = CatchPresenter(view: view,
                                       actions: actions,
                                       dataProvider: MockEmptyCatchDataProvider())
        
        presenter.catchPokemonAction()
        
        XCTAssertTrue(actions.catchCalled)
    }
}
