//
//  HomeViewController.swift
//  Backpack
//
//  Created by Ronan O Ciosig on 15/6/21.
//  Copyright © 2021 Sonomos.com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var button: UIButton!
    
    var presenter: HomePresenting?
    
    @IBAction func backpackButtonAction() {
        button.accessibilityIdentifier = "OpenBackpackButton"
        
        guard let presenter = presenter else { return }
        presenter.backpackButtonAction()
    }
}

extension HomeViewController: HomeView {
    
}
