//
//  CatchViewController.swift
//  CatchUI
//
//  Created by Ronan on 01/07/21.
//  Copyright © 2021 Sonomos. All rights reserved.
//

import UIKit
import Haneke
import Common

public class CatchViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    public var presenter: CatchPresenting?
    var pokemonView: PokemonView?
    
    public override func viewDidLoad() {
        let image = UIImage(named: "Background",
                            in: Bundle(for: CatchViewController.self), with: nil)
        backgroundImageView.image = image
        
        let buttonImage = UIImage(named: "Ball",
                                  in: Bundle(for: CatchViewController.self), with: nil)
        
        button.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func ballAction() {
        dismiss(animated: true) {
            guard let presenter = self.presenter else { return }
            presenter.catchPokemonAction()
        }
    }
}

extension CatchViewController: CatchView {
    func update() {
        guard let presenter = presenter else { return }
        guard let screenPokemon = presenter.pokemon() else { return }
        guard let pokemonView = PokemonView.loadFromNib() else {
            return
        }
        
        pokemonView.name.text = screenPokemon.name
        pokemonView.height.text = "Height: \(screenPokemon.height)"
        pokemonView.weight.text = "Weight: \(screenPokemon.weight)"
        
        view.addSubview(pokemonView)
        
        guard let path = screenPokemon.iconPath else { return }
        guard let imageURL = URL(string: path) else { return }
        
        let placeholderImage = UIImage(named: "PokemonPlaceholder",
                                       in: Bundle(for: CatchViewController.self), with: nil)
        
        pokemonView.imageView.hnk_setImage(from: imageURL, placeholder: placeholderImage)
        pokemonView.imageView.contentMode = .scaleAspectFit
        pokemonView.backgroundColor = UIColor.clear
        pokemonView.center = view.center
    }
    
    func leavePokemonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func showLeaveOrCatchAlert() {
        present(makeLeaveOrCatchAlert(),
                               animated: true,
                               completion: nil)
    }
    
    func makeLeaveOrCatchAlert() -> UIAlertController {
        let alertController = alert(with: Constants.Translations.CatchScene.leaveOrCatchAlertMessageTitle)
        let button = leaveButton(with: Constants.Translations.CatchScene.leaveItButtonTitle)
        button.accessibilityIdentifier = CatchIdentifiers.leaveItButton
        let catchButton = alertButton(with: Constants.Translations.CatchScene.catchItButtonTitle)
        catchButton.accessibilityIdentifier = CatchIdentifiers.catchButton
        alertController.addAction(button)
        alertController.addAction(catchButton)
        alertController.view.accessibilityIdentifier = CatchIdentifiers.alertTitle
        return alertController
    }
    
    func showLeaveItAlert() {
        present(makeLeaveItAlert(),
                animated: true,
                completion: nil)
    }
    
    func makeLeaveItAlert() -> UIAlertController {
        let alertController = alert(with: Constants.Translations.CatchScene.alreadyHaveItAlertMessageTitle)
        let button = leaveButton(with: Constants.Translations.CatchScene.leaveItButtonTitle)
        button.accessibilityIdentifier = CatchIdentifiers.leaveItButton
        alertController.addAction(button)
        alertController.view.accessibilityIdentifier = CatchIdentifiers.alertTitle
        return alertController
    }
    
    func showNotFoundAlert() {
        showError(message: Constants.Translations.CatchScene.noPokemonFoundAlertTitle)
    }
    
    func showError(message: String) {
        let alertController = makeErrorAlert(message: message)
        alertController.view.accessibilityIdentifier = CatchIdentifiers.alertError
        present(alertController,
                animated: true,
                completion: nil)
    }
    
    func makeErrorAlert(message: String) -> UIAlertController {
        let alertController = alert(with: message)
        let okButton = leaveButton(with: Constants.Translations.ok)
        
        alertController.addAction(okButton)
        return alertController
    }
    
    func alert(with title: String) -> UIAlertController {
        return UIAlertController(title: title,
                                 message: nil,
                                 preferredStyle: .alert)
    }
    
    func leaveButton(with title: String) -> UIAlertAction {
        return UIAlertAction(title: title,
                             style: .default) { _ in
                                self.leavePokemonAction()
        }
    }
    
    func alertButton(with title: String) -> UIAlertAction {
        return UIAlertAction(title: title,
                             style: .default,
                             handler: nil)
    }
}
