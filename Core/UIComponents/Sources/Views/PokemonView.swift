//
//  PokemonView.swift
//  UIComponents
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import UIKit

@IBDesignable
public class PokemonView: UIView {
    @IBOutlet public weak var name: UILabel!
    @IBOutlet public weak var weight: UILabel!
    @IBOutlet public weak var height: UILabel!
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var date: UILabel!
    @IBOutlet public weak var types: UILabel!
    @IBOutlet public weak var experience: UILabel!
    
    public func assignIdentifiers() {
        name.accessibilityIdentifier = PokemonViewIdentifiers.name
        weight.accessibilityIdentifier = PokemonViewIdentifiers.weight
        height.accessibilityIdentifier = PokemonViewIdentifiers.height

        imageView.accessibilityIdentifier = PokemonViewIdentifiers.imageView

        date.accessibilityIdentifier = PokemonViewIdentifiers.date
        types.accessibilityIdentifier = PokemonViewIdentifiers.types
        experience.accessibilityIdentifier = PokemonViewIdentifiers.experience
        
        self.accessibilityIdentifier = String(describing: self)
    }
}
