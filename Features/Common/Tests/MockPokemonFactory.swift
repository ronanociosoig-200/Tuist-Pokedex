//
//  MockPokemonFactory.swift
//  CommonTests
//
//  Created by Ronan O Ciosoig on 26/11/22.
//  Copyright © 2022 Sonomos.com. All rights reserved.
//

import Foundation

@testable import Common

let typeElement = TypeElement(slot: 1, type: Species(name: "fire", url: "https://pokeapi.co/api/v2/type/10/"))

struct MockPokemonFactory {
    static func makeScreenPokemon() -> ScreenPokemon {
        ScreenPokemon(name: "cascoon",
                             weight: 115,
                             height: 7,
                             iconPath: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/5.png")
    }
    
    static func makeLocalPokemon() -> LocalPokemon {
        LocalPokemon(name: "cascoon",
                                    weight: 115,
                                    height: 7,
                                    order: 350,
                                    spriteUrlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/268.png",
                                    date: Date(),
                                    species: "cascoon",
                                    baseExperience: 72,
                                    types: ["bug"])
    }
    
    static func makePokemon() -> Pokemon {
        Pokemon(baseExperience: 100,
                height: 7,
                id: 420,
                name: "cascoon",
                order: 1,
                species: Species(name: "cascoon", url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/268.png"),
                sprites: Sprites(backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/5.png",
                                 backFemale: nil,
                                 backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/5.png",
                                 backShinyFemale: nil,
                                 frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/5.png",
                                 frontFemale: nil,
                                 frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/5.png",
                                 frontShinyFemale: nil),
                types: [typeElement],
                weight: 115)
    }
}
