//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func assignIdentifiers() {
        name.accessibilityIdentifier = PokemonCollectionViewCellIdentifiers.name
        imageView.accessibilityIdentifier = PokemonCollectionViewCellIdentifiers.imageView
        self.accessibilityIdentifier = PokemonCollectionViewCellIdentifiers.cell
    }
}
