//
//  Pokemon.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI
import PokemonAPI

struct Pokemon: Decodable, Hashable, Identifiable {

    enum PokemonType: String, Decodable, CaseIterable, Identifiable {
        var id: String { rawValue }

        case fire = "fire"
        case grass = "grass"
        case water = "water"
        case poison = "poison"
        case flying = "flying"
        case electric = "electric"
        case bug = "bug"
    }

    private let pokedexNumber: Int
    let name: String
    let image: String?
    private let primaryType: PokemonType
    private let secondaryType: PokemonType?

    var id: Int { pokedexNumber }

    init(_ name: String,_ types: [String],_ number: Int, image: String? = nil) {
        self.name = name
        pokedexNumber = number
        primaryType = PokemonType(rawValue: types[0].lowercased())!
        secondaryType = types.count > 1 ?
            PokemonType(rawValue: types[1].lowercased()) :
            nil
        self.image = image ?? name
    }

    func formattedNumber() -> String {
        String(format: "#%03d", arguments: [pokedexNumber])
    }

    func types() -> [PokemonType] {
        if secondaryType != nil {
            return [primaryType, secondaryType!]
        }
        return [primaryType]
    }

    func primaryColor() -> Color {
        typeColor(primaryType)
    }

    func secondaryColor() -> Color? {
        secondaryType == nil ? nil : typeColor(secondaryType)
    }
}

extension PKMPokemon {
    func formattedNumber() -> String {
        String(format: "#%03d", arguments: [id ?? 0])
    }

    func primaryType() -> String? {
        guard let primary = types?.first else { return nil }
        return primary.type?.name?.capitalized
    }

    func secondaryType() -> String? {
        let index = 2
        guard index < types?.count ?? 0, let secondary = types?[2] else { return nil }
        return secondary.type?.name?.capitalized
    }

    static func pokemonMock() -> PKMPokemon? {
        guard let path = Bundle.main.path(forResource: "bulbasaur", ofType: "json") else { return nil }

        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("failed data")
            return nil

        }
        
        guard let pokemon: PKMPokemon = try? PKMPokemon.decoder.decode(PKMPokemon.self, from: jsonData) else {
            print("failed decoder")
            return nil
        }
        
        return pokemon
    }
}
