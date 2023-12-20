//
//  Coordinator.swift
//  UIComponentsExample
//
//  Created by Ronan on 25/01/2023.
//  Copyright © 2023 eDreams. All rights reserved.
//

import UIKit
import Common
import UIComponents

class Coordinator {
    let window: UIWindow
    var currentViewController: UIViewController?

    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    func start() {
        showHomeScene()
    }

    func showHomeScene() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        window.rootViewController = viewController
    }
    
    func addView(viewController: UIViewController) {
        let view = PokemonView.loadFromNib()
        viewController.view.addSubview(view!)
    }
}

class ComponentViewController: UIViewController {
    override func viewDidLoad() {
        guard let pokemonView = PokemonView.loadFromNib() else {
            return
        }
        pokemonView.center = view.center
        var point = pokemonView.center
        let height = pokemonView.frame.size.height
        point.y = height/2
        pokemonView.center = point
        
        view.addSubview(pokemonView)
        
        pokemonView.translatesAutoresizingMaskIntoConstraints = false
        
        let diameter: CGFloat = 140
        
        NSLayoutConstraint.activate([
            pokemonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pokemonView.widthAnchor.constraint(equalToConstant: diameter),
            pokemonView.heightAnchor.constraint(equalToConstant: diameter)
        ])
    }
}

















