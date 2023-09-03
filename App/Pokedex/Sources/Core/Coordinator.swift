//
//  Coordinator.swift
//  Pokedex
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Foundation
import os.log

import Home
import Catch
import Backpack
import Detail

import JGProgressHUD
import NetworkKit
import Common

class Coordinator: Coordinating {
    let window: UIWindow
    var dataProvider: DataProvider?
    var hud: JGProgressHUD?
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
        let viewController = HomeWireframe.makeViewController()
        HomeWireframe.prepare(viewController, actions: actions as HomeActions, dataProvider: dataProvider as HomeDataProvider)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        
        os_log("Info: %s", log: Log.general, type: .info, "showHomeScene")
    }
    
    func showCatchScene(identifier: Int?) {
        guard let dataProvider = dataProvider else { return }
        let viewController = CatchWireframe.makeViewController()
        
        CatchWireframe.prepare(viewController, actions: actions as CatchActions, dataProvider: dataProvider as CatchDataProvider)
        
        guard let topViewController = window.rootViewController as? UINavigationController else { return }
        
        topViewController.present(viewController, animated: true, completion: nil)
        //topViewController.pushViewController(viewController, animated: false)
        presenter = viewController.presenter as? Updatable
        
        currentViewController = viewController
        
        searchNextPokemon(identifier: identifier)
        
        showLoading()
    }
    
    func searchNextPokemon(identifier: Int?) {
        guard let dataProvider = dataProvider else { return }
        let networkService = PokemonSearchService()
        if let identifier = identifier {
            dataProvider.search(identifier: identifier, networkService: networkService)
        } else {
            dataProvider.search(identifier: Generator.nextIdentifier(), networkService: networkService)
        }
    }
    
    func showBackpackScene() {
        guard let dataProvider = dataProvider else { return }
        
        let navigationController = BackpackWireframe.makeNavigationController()
        guard let viewController = navigationController.topViewController as? BackpackViewController else { return }
        
        BackpackWireframe.prepare(viewController,
                                  actions: actions as BackpackActions,
                                  dataProvider: dataProvider as BackpackDataProvider)
        
        guard let topViewController = window.rootViewController else { return }
        
        topViewController.present(navigationController, animated: true, completion: nil)
        
        currentViewController = navigationController
    }
    
    func showPokemonDetailScene(pokemon: LocalPokemon) {
        let viewController = PokemonDetailWireframe.makeViewController()
        
        PokemonDetailWireframe.prepare(viewController, pokemon: pokemon)
        
        guard let topViewController = currentViewController as? UINavigationController else { return }
        
        topViewController.pushViewController(viewController, animated: true)
    }
    
    func showLoading() {
        showHud(with: Constants.Translations.loading)
    }
    
    private func showHud(with message: String) {
        guard let viewController = currentViewController else { return }
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = message
        hud?.show(in: viewController.view)
    }
    
    func dismissLoading() {
        hud?.dismiss(animated: true)
        hud = nil
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
