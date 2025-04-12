//
//  DetailPresenter.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import SwiftUI
import Combine

class DetailPresenter: ObservableObject {
  
  private var cancellables: Set<AnyCancellable> = []
  private let detailUseCase: DetailUseCase
  
  @Published var game: GameModel?
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false
  @Published var isError: Bool = false
  @Published var isFavorite: Bool = false
  
  init(detailUseCase: DetailUseCase) {
    self.detailUseCase = detailUseCase
    checkIsFavorite()
  }
  
  func getGameDetail() {
    isLoading = true
    detailUseCase.getGameDetail()
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
      }, receiveValue: { game in
        self.game = game
      })
      .store(in: &cancellables)
  }
  
  func checkIsFavorite() {
    detailUseCase.checkIsFavorite()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { status in
              self.isFavorite = status
            })
      .store(in: &cancellables)
  }
  
  func updateFavoriteStatus() {
    if isFavorite {
      detailUseCase.removeFromFavorite()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in },
              receiveValue: { _ in
                self.isFavorite = false
              })
        .store(in: &cancellables)
    } else {
      detailUseCase.addToFavorite()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in },
              receiveValue: { _ in
                self.isFavorite = true
              })
        .store(in: &cancellables)
    }
  }
}
