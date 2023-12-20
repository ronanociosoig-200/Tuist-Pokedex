//
//  Constants.swift
//  NetworkKitExample
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Foundation

struct Constants {
    struct Translations {
        static let loading = "Loading"
        static let ok = "OK"
        static let cancel = "Cancel"
        
        struct HomeScene {
            static let catchTitle = "Catch a Pokemon"
        }
        
        struct CatchScene {
            static let weight = "WEIGHT"
            static let height = "HEIGHT"
            static let leaveOrCatchAlertMessageTitle = "Do you want to leave it or catch it?"
            static let leaveItButtonTitle = "Leave it"
            static let catchItButtonTitle = "Catch it!"
            static let alreadyHaveItAlertMessageTitle = "You have already caught one of this species, you'll have to leave this one..."
            
            static let noPokemonFoundAlertTitle = "No Pokemon found, you will have to try again."
            
        }
        
        struct SimpleView {
            
            static let title = "Network Example"
            static let labelText = "Choose a Pokemon"
            
            static let placeholder = "A number between 1 and 1000"
            
            struct Button {
                static let search = "Search"
            }
            
            struct Alert {
                
                static let found = "Pokemon found: "
                
                struct Error {
                    static let enterVlidNumber = "Enter valid number"
                    static let outOfRange = "Number out of range"
                    static let nameNotFound = "Unknown"
                }
                
            }
        }
    }
    
    enum PokemonAPI {
        static let minIdentifier = 1
        static let maxIdentifier = 1000
    }
}
