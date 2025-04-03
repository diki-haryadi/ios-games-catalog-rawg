//
//  HomeRouter.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import SwiftUI

class HomeRouter {
  
  func makeDetailView(for gameId: Int) -> some View {
    let detailUseCase = Injection.init().provideDetail(gameId: gameId)
    let presenter = DetailPresenter(detailUseCase: detailUseCase)
    return DetailView(presenter: presenter)
  }
  
}
