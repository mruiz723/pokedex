//
//  MovesViewModel.swift
//  Pokedex
//
//  Created by Marlon David Ruiz Arroyave on 7/03/21.
//

import Foundation
import PokemonAPI
import Combine

class MovesViewModel: ObservableObject {
    @Published var moves = [PKMMove]()
    @Published var isLoadingPage = false

    private var subscriptions: Set<AnyCancellable> = []
    private var pageObject: PageObject?

    func fetchMoves() {
        isLoadingPage = true
        guard PokemonAPI.movesOffset + PokemonAPI.limit <= PokemonAPI.count, let url = Endpoint.moves().url else { return }
        var newMoves: [PKMMove] = []

        PokemonAPI.fetchMoveList(url: url)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { pageObject in
                self.pageObject = pageObject
                PokemonAPI.count = pageObject.count

                pageObject.results?.forEach { [weak self] namedAPIResource  in
                    guard let self = self else { return }
                    print("loading \(namedAPIResource.url)")
                    self.fetchMove(by: namedAPIResource.name)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print("failed: \(error)")
                            }
                        }, receiveValue: { move in
                            print("type: \(String(describing: move.name))")
                            newMoves.append(move)
                            if newMoves.count == PokemonAPI.limit {
                                self.isLoadingPage = false
                                self.moves.removeAll()
                                newMoves.sort(by: {
                                    $0.id! < $1.id!
                                })
                                print("moves: \(newMoves.count)")
                                self.moves.append(contentsOf: newMoves)
                            }
                        }).store(in: &self.subscriptions)
                }
            }).store(in: &subscriptions)
    }

    func fetchMove(by name: String) -> AnyPublisher<PKMMove, Error> {
        return PokemonAPI().moveService.fetchMove(name)
    }

    // Initial shimmer data
    // Showing until data is loading
    func loadTempData() {
        var moves: [PKMMove] = []

        for _ in 1...20 {
            guard let temp = PKMMove.moveMock() else { return }
            moves.append(temp)
        }

        self.moves = moves
    }

    func fetchMoreListMoves() {
        guard !isLoadingPage, let shimmerPokemon = PKMMove.moveMock(), let url = Endpoint.moves().url else { return }
        isLoadingPage = true
        moves.append(shimmerPokemon)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            guard PokemonAPI.movesOffset + PokemonAPI.limit <= PokemonAPI.count else { return }
            var newMoves: [PKMMove] = []

            PokemonAPI.fetchMoveList(url: url)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                    }
                }, receiveValue: { pageObject in
                    self.pageObject = pageObject
                    PokemonAPI.count = pageObject.count
                    pageObject.results?.forEach { [weak self] namedAPIResource  in
                        print("loading \(namedAPIResource.url)")
                        guard let self = self else { return }
                        self.fetchMove(by: namedAPIResource.name)
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    break
                                case .failure(let error):
                                    print("failed: \(error)")
                                }
                            }, receiveValue: { pokemon in
                                newMoves.append(pokemon)
                                if newMoves.count == PokemonAPI.limit {
                                    self.isLoadingPage = false
                                    self.moves.removeLast()
                                    newMoves.sort(by: {
                                        $0.id! < $1.id!
                                    })
                                    print("moves: \(newMoves.count)")
                                    self.moves.append(contentsOf: newMoves)
                                }
                            }).store(in: &self.subscriptions)
                    }
                }).store(in: &self.subscriptions)
        }
    }
}

