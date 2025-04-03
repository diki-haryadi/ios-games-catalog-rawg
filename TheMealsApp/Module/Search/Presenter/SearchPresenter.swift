//
//  SearchPresenter.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI
import Combine

class SearchPresenter: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let searchUseCase: SearchUseCase
    private let repository: GameRepositoryProtocol
    
    @Published var games: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init(searchUseCase: SearchUseCase, repository: GameRepositoryProtocol) {
        self.searchUseCase = searchUseCase
        self.repository = repository
    }
    
    func searchGames(query: String) {
        isLoading = true
        games = []
        
        searchUseCase.searchGames(query: query)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { games in
                self.games = games
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite(game: GameModel, isFavorite: Bool) {
        if isFavorite {
            repository.addToFavorite(game: game)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    case .finished:
                        print("Game added to favorites")
                    }
                }, receiveValue: { _ in
                    // Update the game in the list
                    if let index = self.games.firstIndex(where: { $0.id == game.id }) {
                        let updatedGame = GameModel(
                            id: game.id,
                            name: game.name,
                            released: game.released,
                            backgroundImage: game.backgroundImage,
                            rating: game.rating,
                            ratingCount: game.ratingCount,
                            description: game.description,
                            genres: game.genres,
                            platforms: game.platforms,
                            isFavorite: true
                        )
                        self.games[index] = updatedGame
                    }
                })
                .store(in: &cancellables)
        } else {
            repository.removeFromFavorite(id: game.id)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    case .finished:
                        print("Game removed from favorites")
                    }
                }, receiveValue: { _ in
                    // Update the game in the list
                    if let index = self.games.firstIndex(where: { $0.id == game.id }) {
                        let updatedGame = GameModel(
                            id: game.id,
                            name: game.name,
                            released: game.released,
                            backgroundImage: game.backgroundImage,
                            rating: game.rating,
                            ratingCount: game.ratingCount,
                            description: game.description,
                            genres: game.genres,
                            platforms: game.platforms,
                            isFavorite: false
                        )
                        self.games[index] = updatedGame
                    }
                })
                .store(in: &cancellables)
        }
    }
}
