//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI

struct PokemonDetailView: View {
    @Binding var showTabBar: Bool

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                showTabBar.toggle()
            }
            .onDisappear {
                showTabBar.toggle()
            }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(showTabBar: .constant(false))
    }
}
