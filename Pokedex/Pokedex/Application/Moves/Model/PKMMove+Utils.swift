//
//  PKMMove+Utils.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 7/03/21.
//

import Foundation
import PokemonAPI

extension PKMMove {
    static func moveMock() -> PKMMove? {
        guard let path = Bundle.main.path(forResource: "stompMove", ofType: "json") else { return nil }

        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("failed data")
            return nil

        }

        guard let move: PKMMove = try? PKMMove.decoder.decode(PKMMove.self, from: jsonData) else {
            print("failed decoder")
            return nil
        }

        return move
    }
}
