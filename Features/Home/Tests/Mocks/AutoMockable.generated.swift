// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import UIKit

@testable import Home
@testable import Common

class AppDataHandlingMock: AppDataHandling {
    var pokemon: Pokemon?
    var pokemons: [LocalPokemon] = []

    //MARK: - newSpecies

    var newSpeciesCallsCount = 0
    var newSpeciesCalled: Bool {
        return newSpeciesCallsCount > 0
    }
    var newSpeciesReturnValue: Bool!
    var newSpeciesClosure: (() -> Bool)?

    func newSpecies() -> Bool {
        newSpeciesCallsCount += 1
        return newSpeciesClosure.map({ $0() }) ?? newSpeciesReturnValue
    }

    //MARK: - load

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var loadReturnValue: Void!
    var loadClosure: (() -> Void)?

    func load() {
        loadCallsCount += 1
        loadClosure?()
    }

    //MARK: - save

    var saveCallsCount = 0
    var saveCalled: Bool {
        return saveCallsCount > 0
    }
    var saveReturnValue: Void!
    var saveClosure: (() -> Void)?

    func save() {
        saveCallsCount += 1
        saveClosure?()
    }

    //MARK: - directory

    var directoryCallsCount = 0
    var directoryCalled: Bool {
        return directoryCallsCount > 0
    }
    var directoryReturnValue: Directory!
    var directoryClosure: (() -> Directory)?

    func directory() -> Directory {
        directoryCallsCount += 1
        return directoryClosure.map({ $0() }) ?? directoryReturnValue
    }

    //MARK: - sortByOrder

    var sortByOrderCallsCount = 0
    var sortByOrderCalled: Bool {
        return sortByOrderCallsCount > 0
    }
    var sortByOrderReturnValue: Void!
    var sortByOrderClosure: (() -> Void)?

    func sortByOrder() {
        sortByOrderCallsCount += 1
        sortByOrderClosure?()
    }

    //MARK: - clean

    var cleanCallsCount = 0
    var cleanCalled: Bool {
        return cleanCallsCount > 0
    }
    var cleanReturnValue: Void!
    var cleanClosure: (() -> Void)?

    func clean() {
        cleanCallsCount += 1
        cleanClosure?()
    }

}

class CoordinatingMock: Coordinating {
    var dataProvider: DataProvider?

    //MARK: - start

    var startCallsCount = 0
    var startCalled: Bool {
        return startCallsCount > 0
    }
    var startReturnValue: Void!
    var startClosure: (() -> Void)?

    func start() {
        startCallsCount += 1
        startClosure?()
    }

    //MARK: - showLoading

    var showLoadingCallsCount = 0
    var showLoadingCalled: Bool {
        return showLoadingCallsCount > 0
    }
    var showLoadingReturnValue: Void!
    var showLoadingClosure: (() -> Void)?

    func showLoading() {
        showLoadingCallsCount += 1
        showLoadingClosure?()
    }

    //MARK: - dismissLoading

    var dismissLoadingCallsCount = 0
    var dismissLoadingCalled: Bool {
        return dismissLoadingCallsCount > 0
    }
    var dismissLoadingReturnValue: Void!
    var dismissLoadingClosure: (() -> Void)?

    func dismissLoading() {
        dismissLoadingCallsCount += 1
        dismissLoadingClosure?()
    }

    //MARK: - showHomeScene

    var showHomeSceneCallsCount = 0
    var showHomeSceneCalled: Bool {
        return showHomeSceneCallsCount > 0
    }
    var showHomeSceneReturnValue: Void!
    var showHomeSceneClosure: (() -> Void)?

    func showHomeScene() {
        showHomeSceneCallsCount += 1
        showHomeSceneClosure?()
    }

    //MARK: - showCatchScene

    var showCatchSceneIdentifierCallsCount = 0
    var showCatchSceneIdentifierCalled: Bool {
        return showCatchSceneIdentifierCallsCount > 0
    }
    var showCatchSceneIdentifierReturnValue: Void!
    var showCatchSceneIdentifierReceivedIdentifier: Int?
    var showCatchSceneIdentifierReceivedInvocations: [Int?] = []
    var showCatchSceneIdentifierClosure: ((Int?) -> Void)?

    func showCatchScene(identifier: Int?) {
        showCatchSceneIdentifierCallsCount += 1
        showCatchSceneIdentifierReceivedIdentifier = identifier
        showCatchSceneIdentifierReceivedInvocations.append(identifier)
        showCatchSceneIdentifierClosure?(identifier)
    }

    //MARK: - showBackpackScene

    var showBackpackSceneCallsCount = 0
    var showBackpackSceneCalled: Bool {
        return showBackpackSceneCallsCount > 0
    }
    var showBackpackSceneReturnValue: Void!
    var showBackpackSceneClosure: (() -> Void)?

    func showBackpackScene() {
        showBackpackSceneCallsCount += 1
        showBackpackSceneClosure?()
    }

    //MARK: - showPokemonDetailScene

    var showPokemonDetailScenePokemonCallsCount = 0
    var showPokemonDetailScenePokemonCalled: Bool {
        return showPokemonDetailScenePokemonCallsCount > 0
    }
    var showPokemonDetailScenePokemonReturnValue: Void!
    var showPokemonDetailScenePokemonReceivedPokemon: LocalPokemon?
    var showPokemonDetailScenePokemonReceivedInvocations: [LocalPokemon] = []
    var showPokemonDetailScenePokemonClosure: ((LocalPokemon) -> Void)?

    func showPokemonDetailScene(pokemon: LocalPokemon) {
        showPokemonDetailScenePokemonCallsCount += 1
        showPokemonDetailScenePokemonReceivedPokemon = pokemon
        showPokemonDetailScenePokemonReceivedInvocations.append(pokemon)
        showPokemonDetailScenePokemonClosure?(pokemon)
    }

    //MARK: - showAlert

    var showAlertWithCallsCount = 0
    var showAlertWithCalled: Bool {
        return showAlertWithCallsCount > 0
    }
    var showAlertWithReturnValue: Void!
    var showAlertWithReceivedErrorMessage: String?
    var showAlertWithReceivedInvocations: [String] = []
    var showAlertWithClosure: ((String) -> Void)?

    func showAlert(with errorMessage: String) {
        showAlertWithCallsCount += 1
        showAlertWithReceivedErrorMessage = errorMessage
        showAlertWithReceivedInvocations.append(errorMessage)
        showAlertWithClosure?(errorMessage)
    }

}

class DataProvidingMock: DataProviding {

    //MARK: - catchPokemon

    var catchPokemonCallsCount = 0
    var catchPokemonCalled: Bool {
        return catchPokemonCallsCount > 0
    }
    var catchPokemonReturnValue: Void!
    var catchPokemonClosure: (() -> Void)?

    func catchPokemon() {
        catchPokemonCallsCount += 1
        catchPokemonClosure?()
    }

    //MARK: - newSpecies

    var newSpeciesCallsCount = 0
    var newSpeciesCalled: Bool {
        return newSpeciesCallsCount > 0
    }
    var newSpeciesReturnValue: Bool!
    var newSpeciesClosure: (() -> Bool)?

    func newSpecies() -> Bool {
        newSpeciesCallsCount += 1
        return newSpeciesClosure.map({ $0() }) ?? newSpeciesReturnValue
    }

    //MARK: - pokemon

    var pokemonAtCallsCount = 0
    var pokemonAtCalled: Bool {
        return pokemonAtCallsCount > 0
    }
    var pokemonAtReturnValue: LocalPokemon!
    var pokemonAtReceivedIndex: Int?
    var pokemonAtReceivedInvocations: [Int] = []
    var pokemonAtClosure: ((Int) -> LocalPokemon)?

    func pokemon(at index: Int) -> LocalPokemon {
        pokemonAtCallsCount += 1
        pokemonAtReceivedIndex = index
        pokemonAtReceivedInvocations.append(index)
        return pokemonAtClosure.map({ $0(index) }) ?? pokemonAtReturnValue
    }

}

class HomeActionsMock: HomeActions {

    //MARK: - ballButtonAction

    var ballButtonActionCallsCount = 0
    var ballButtonActionCalled: Bool {
        return ballButtonActionCallsCount > 0
    }
    var ballButtonActionReturnValue: Void!
    var ballButtonActionClosure: (() -> Void)?

    func ballButtonAction() {
        ballButtonActionCallsCount += 1
        ballButtonActionClosure?()
    }

    //MARK: - backpackButtonAction

    var backpackButtonActionCallsCount = 0
    var backpackButtonActionCalled: Bool {
        return backpackButtonActionCallsCount > 0
    }
    var backpackButtonActionReturnValue: Void!
    var backpackButtonActionClosure: (() -> Void)?

    func backpackButtonAction() {
        backpackButtonActionCallsCount += 1
        backpackButtonActionClosure?()
    }

}

class HomePresentingMock: HomePresenting {

    //MARK: - ballButtonAction

    var ballButtonActionCallsCount = 0
    var ballButtonActionCalled: Bool {
        return ballButtonActionCallsCount > 0
    }
    var ballButtonActionReturnValue: Void!
    var ballButtonActionClosure: (() -> Void)?

    func ballButtonAction() {
        ballButtonActionCallsCount += 1
        ballButtonActionClosure?()
    }

    //MARK: - backpackButtonAction

    var backpackButtonActionCallsCount = 0
    var backpackButtonActionCalled: Bool {
        return backpackButtonActionCallsCount > 0
    }
    var backpackButtonActionReturnValue: Void!
    var backpackButtonActionClosure: (() -> Void)?

    func backpackButtonAction() {
        backpackButtonActionCallsCount += 1
        backpackButtonActionClosure?()
    }

}

class HomeViewMock: HomeView {

}

class NotifierMock: Notifier {

    //MARK: - dataReceived

    var dataReceivedErrorMessageOnCallsCount = 0
    var dataReceivedErrorMessageOnCalled: Bool {
        return dataReceivedErrorMessageOnCallsCount > 0
    }
    var dataReceivedErrorMessageOnReturnValue: Void!
    var dataReceivedErrorMessageOnReceivedArguments: (errorMessage: String?, queue: DispatchQueue?)?
    var dataReceivedErrorMessageOnReceivedInvocations: [(errorMessage: String?, queue: DispatchQueue?)] = []
    var dataReceivedErrorMessageOnClosure: ((String?, DispatchQueue?) -> Void)?

    func dataReceived(errorMessage: String?, on queue: DispatchQueue?) {
        dataReceivedErrorMessageOnCallsCount += 1
        dataReceivedErrorMessageOnReceivedArguments = (errorMessage: errorMessage, queue: queue)
        dataReceivedErrorMessageOnReceivedInvocations.append((errorMessage: errorMessage, queue: queue))
        dataReceivedErrorMessageOnClosure?(errorMessage, queue)
    }

}

class UpdatableMock: Updatable {

    //MARK: - update

    var updateCallsCount = 0
    var updateCalled: Bool {
        return updateCallsCount > 0
    }
    var updateReturnValue: Void!
    var updateClosure: (() -> Void)?

    func update() {
        updateCallsCount += 1
        updateClosure?()
    }

    //MARK: - showError

    var showErrorMessageCallsCount = 0
    var showErrorMessageCalled: Bool {
        return showErrorMessageCallsCount > 0
    }
    var showErrorMessageReturnValue: Void!
    var showErrorMessageReceivedMessage: String?
    var showErrorMessageReceivedInvocations: [String] = []
    var showErrorMessageClosure: ((String) -> Void)?

    func showError(message: String) {
        showErrorMessageCallsCount += 1
        showErrorMessageReceivedMessage = message
        showErrorMessageReceivedInvocations.append(message)
        showErrorMessageClosure?(message)
    }

}


