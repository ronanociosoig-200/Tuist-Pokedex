//
//  Coordinator.swift
//  Pokedex
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Foundation
import JGProgressHUD
import Common
import Home

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
        
        window.rootViewController = viewController
    }
    
    func showCatchScene(identifier: Int?) {
        let viewController = makeViewController(with: HomeExampleIdentifiers.mockCatchScene)
        viewController.view.backgroundColor = UIColor.systemBackground
        
        guard let topViewController = window.rootViewController else { return }
        
        topViewController.present(viewController, animated: true, completion: nil)
        
        currentViewController = viewController
        
        showLoading()
    }
    
    func searchNextPokemon() {

    }
    
    func showBackpackScene() {
        let viewController = makeViewController(with: HomeExampleIdentifiers.mockBackpackScene)
        
        guard let topViewController = window.rootViewController else { return }

        topViewController.present(viewController, animated: true, completion: nil)

        currentViewController = viewController
    }
    
    func showPokemonDetailScene(pokemon: LocalPokemon) {
        
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

extension Coordinator {
    func makeViewController(with text: String) -> UIViewController {
        let viewController = UIViewController()
        let label = UILabel()
        
        viewController.view.backgroundColor = UIColor.systemBackground
        
        label.text = text
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.accessibilityIdentifier = text
        
        viewController.view.addSubview(label)
        viewController.view.accessibilityIdentifier = text
        
        guard let view = viewController.view else {
            return viewController
        }

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                           label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                           label.heightAnchor.constraint(equalToConstant: 40),
                                           label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                                           ])
        return viewController
    }
}
