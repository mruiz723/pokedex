//
//  MovesView.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 27/02/21.
//

import SwiftUI
import Kingfisher
import PokemonAPI

struct MovesView: View {
    @Binding var showTabBar: Bool
    @Binding var selectedTab: TabItem
    @State var didAppear = false
    @StateObject var viewModel = MovesViewModel()
    // For tracking
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()

    var body: some View {
        NavigationView {
            List(viewModel.moves, id: \.id) { move in
                if selectedTab == .moves {
                    if move.name == "" {
                        ShimmerMoveRow()
                    } else {
                        // Going to track end of data...
                        ZStack {
                            if viewModel.moves.last?.id == move.id {
                                GeometryReader { geometry in
                                    MoveRow(move: move)
                                        .onAppear {
                                            self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                        }
                                        .onReceive(self.time) { _ in
                                            if geometry.frame(in: .global).maxY > UIScreen.main.bounds.height - 160 {
                                                self.time.upstream.connect()
                                                    .cancel()
                                                print("Update data...")
                                                viewModel.fetchMoreListMoves()
                                            }
                                        }
                                }
                            } else {
                                MoveRow(move: move)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Moves")
            .onChange(of: selectedTab) { _ in
                onLoad()
            }
        }
    }

    private func onLoad() {
        guard selectedTab == .moves else { return }
        if !didAppear {
            if viewModel.moves.count == 0 {
                PokemonAPI.movesOffset = 0
                viewModel.loadTempData()
                viewModel.fetchMoves()
            }
        }
        didAppear = !didAppear
    }
}

struct MovesView_Previews: PreviewProvider {
    static var previews: some View {
        MovesView(showTabBar: .constant(false), selectedTab: .constant(.moves))
    }
}
