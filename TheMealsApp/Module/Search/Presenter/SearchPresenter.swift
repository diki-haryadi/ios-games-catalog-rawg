//
//  SearchPresenter.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI
import Combine

class SearchPresenter: ObservableObject {
  
  private var cancellables: Set<AnyCancellable> = []
  private let router = SearchRouter()
  private let searchUseCase: SearchUseCase
  
  @Published var games: [GameModel] = []
  @Published var searchQuery: String = ""
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false
  @Published var isError: Bool = false
  
  init(searchUseCase: SearchUseCase) {
    self.searchUseCase = searchUseCase
    
    $searchQuery
      .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
      .removeDuplicates()
      .filter { !$0.isEmpty }
      .sink(receiveValue: { [weak self] query in
        self?.searchGames(query: query)
      })
      .store(in: &cancellables)
  }
  
  func searchGames(query: String) {
    isLoading = true
    searchUseCase.searchGames(query: query)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { games in
        self.games = games
      })
      .store(in: &cancellables)
  }
  
  func linkBuilder<Content: View>(
    for gameId: Int,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(destination: router.makeDetailView(for: gameId)) { content() }
  }
}
