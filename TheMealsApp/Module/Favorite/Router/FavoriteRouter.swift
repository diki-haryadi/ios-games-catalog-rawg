//
//  FavoriteRouter.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI

class FavoriteRouter {
  
  func makeDetailView(for gameId: Int) -> some View {
    let detailUseCase = Injection.init().provideDetail(gameId: gameId)
    let presenter = DetailPresenter(detailUseCase: detailUseCase)
    return DetailView(presenter: presenter)
  }
  
}
