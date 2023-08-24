//
//  HomeViewController.swift
//  Catch
//
//  Created by Ronan O Ciosig on 01/07/21.
//  Copyright © 2021 Sonomos.com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var catchFixedButton: UIButton!
    @IBOutlet var catchErrorButton: UIButton!
    @IBOutlet var leaveItButton: UIButton!
    
    var presenter: HomePresenting?
    
    override func viewDidLoad() {
        catchButton.accessibilityIdentifier = HomeIdentifiers.catchButton
        catchFixedButton.accessibilityIdentifier = HomeIdentifiers.catchFixedButton
        catchErrorButton.accessibilityIdentifier = HomeIdentifiers.catchErrorButton
        leaveItButton.accessibilityIdentifier = HomeIdentifiers.leaveItButton
    }
    
    @IBAction func catchButtonAction() {
        guard let presenter = presenter else { return }
        presenter.catchButtonAction()
    }
    
    @IBAction func catchFixedButtonAction() {
        guard let presenter = presenter else { return }
        presenter.catchFixedButtonAction()
    }
    
    @IBAction func catchErrorButtonAction() {
        guard let presenter = presenter else { return }
        presenter.catchErrorButtonAction()
    }
    
    @IBAction func leaveItButtonAction() {
        guard let presenter = presenter else { return }
        presenter.leaveItButtonAction()
    }
}

extension HomeViewController: HomeView {
    
}
