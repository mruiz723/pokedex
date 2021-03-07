//
//  PokemonView.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI
import Kingfisher
import PokemonAPI

struct PokemonView: View {
    @Binding var showTabBar: Bool
    @State var didAppear = false
    @StateObject var viewModel = PokemonViewModel()
    // For tracking
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()

    var body: some View {
        NavigationView {
            List(viewModel.pokemons, id: \.id) { pokemon in
                NavigationLink(destination: PokemonDetailView(showTabBar: $showTabBar)) {
                    if pokemon.name == "" {
                        ShimmerRow()
                    } else {
                        // Going to track end of data...
                        ZStack {
                            if viewModel.pokemons.last?.id == pokemon.id {
                                GeometryReader { geometry in
                                    PokemonRow(pokemon: pokemon)
                                        .onAppear {
                                            self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                        }
                                        .onReceive(self.time) { _ in
                                            if geometry.frame(in: .global).maxY < UIScreen.main.bounds.height {
                                                self.time.upstream.connect()
                                                    .cancel()
                                                print("Update data...")
                                                viewModel.fetchMoreListPockemons()
                                            }
                                        }
                                }
                            } else {
                                PokemonRow(pokemon: pokemon)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pokemon")
            .onAppear(perform: onLoad)
        }
    }

    private func onLoad() {
        if !didAppear {
            if viewModel.pokemons.count == 0 {
                PokemonAPI.offset = 0
                viewModel.loadTempData()
                viewModel.fetchPokemons()
            }
        }
        didAppear = !didAppear
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonView(showTabBar: .constant(false))
    }
}
