//
//  Coordinator.swift
//  DetailExample
//
//  Created by Ronan on 12/09/2021.
//  Copyright © 2021 Sonomos. All rights reserved.
//

import UIKit
import Common
import Detail

class Coordinator: Coordinating {
    let window: UIWindow
    var dataProvider: DataProvider?

    lazy var actions = Actions(coordinator: self)
    var presenter: Updatable?
    var currentViewController: UIViewController?

    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    func start() {
        actions.dataProvider = dataProvider

        showHomeScene()
    }

    func showHomeScene() {
        guard let dataProvider = dataProvider else { return }
        let viewController = PokemonDetailWireframe.makeViewController()
        guard let pokemon = dataProvider.appData.pokemons.first else { return }
        
        PokemonDetailWireframe.prepare(viewController, pokemon: pokemon)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
    }

    func showCatchScene(identifier: Int?) {

    }

    func searchNextPokemon() {

    }

    func showBackpackScene() {

    }

    func showPokemonDetailScene(pokemon: LocalPokemon) {

    }

    func showLoading() {
        showHud(with: Constants.Translations.loading)
    }

    private func showHud(with message: String) {

    }

    func dismissLoading() {

    }

    func showAlert(with message: String) {
        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)

        let okButton = UIAlertAction(title: Constants.Translations.ok,
                                     style: .default,
                                     handler: nil)

        alertController.addAction(okButton)

        guard let viewController = currentViewController else { return }

        viewController.present(alertController,
                               animated: true,
                               completion: nil)
    }
}

extension Coordinator: Notifier {
    func dataReceived(errorMessage: String?, on queue: DispatchQueue?) {

        var localQueue = queue

        if localQueue == nil {
            localQueue = .global(qos: .userInteractive)
        }

        localQueue?.async {
            self.dismissLoading()

            if let errorMessage = errorMessage {
                if errorMessage == Constants.Translations.Error.statusCode404 {
                    self.presenter?.update()
                    return
                }
                self.presenter?.showError(message: errorMessage)
            } else {
                self.presenter?.update()
            }
        }
    }
}
