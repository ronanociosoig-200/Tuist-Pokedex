//
//  AppData.swift
//  Common
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Foundation

public protocol AppDataHandling {
    var pokemon: Pokemon? { get set }
    var pokemons: [LocalPokemon] { get set }
    
    func newSpecies() -> Bool
    func load()
    func save()
    func directory() -> Directory
    func sortByOrder()
    func clean()
}

public class AppData: AppDataHandling {
    public static let pokemonFile = "pokemons.json"
    
    public var pokemon: Pokemon?
    public var pokemons = [LocalPokemon]()
    private let dummyValue = 3
    
    let storage: Storable
    
    public init(storage: Storable) {
        self.storage = storage
    }
    
    public func newSpecies() -> Bool {
        guard let pokemon = pokemon else { return false }
        
        if pokemons.isEmpty {
            return true
        }
        
        let foundSpecies = pokemons.filter {
            $0.species == pokemon.species.name
        }
        
        return foundSpecies.isEmpty
    }
    
    public func load() {
        pokemons = storage.load(AppData.pokemonFile,
                                from: directory(),
                                as: [LocalPokemon].self) ?? [LocalPokemon]()
    }
    
    public func save() {
        storage.save(pokemons,
                     to: directory(),
                     as: AppData.pokemonFile)
    }
    
    public func clean() {
        storage.remove(AppData.pokemonFile, from: directory())
    }
    
    public func directory() -> Directory {
        if Configuration.uiTesting {
            return .caches
        }
        return .documents
    }
    
    public func sortByOrder() {
        pokemons.sort(by: {
            $0.order < $1.order
        })
    }
    
    public func getDummy() -> Int {
        return dummyValue
    }
    
    public func setDummy(value: Int) {
        // Do nothing
    }
}
