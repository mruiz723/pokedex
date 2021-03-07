//
//  PokemonRow.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI
import PokemonAPI
import Kingfisher

struct PokemonRow: View {
    let pokemon: PKMPokemon?
    
    var body: some View {
        HStack {
            KFImage(URL(string: pokemon?.sprites?.frontDefault ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
                .resizable()
                .padding(-10.0)
                .frame(width: 68, height: 68, alignment: .center)

            VStack(alignment: .leading) {
                Text(pokemon?.name?.capitalized ?? "")
                    .font(.headline)
                    .fontWeight(.regular)
                Text(pokemon?.formattedNumber() ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }

            Spacer()

            if let nameSecondaryType = pokemon?.secondaryType() {
                Image(nameSecondaryType)
            }

            if let namefirstType = pokemon?.primaryType() {
                Image(namefirstType)
            }
        }
        .padding(.horizontal, 20.0)
    }
}

struct PokemonRow_Previews: PreviewProvider {

    static var previews: some View {
        PokemonRow(pokemon: PKMPokemon.pokemonMock())
    }
}
