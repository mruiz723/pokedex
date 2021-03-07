//
//  MainView.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    @State var showTabBar: Bool = true

    var body: some View {
        TabView(selection: $selection) {
            PokemonView(showTabBar: $showTabBar)
                .tabItem {
                    Label("Pokemon", image: selection == 0 ? "pokemonActive" : "pokemon")
                }
                .tag(0)
            MovesView()
                .tabItem {
                    Label("Moves", image: selection == 1 ? "movesActive" : "moves")
                }
                .tag(1)
            ItensView()
                .tabItem {
                    Label("Itens", image: selection == 2 ? "itensActive" : "itens")
                }
                .tag(2)
        }
        .accentColor(.black)
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
