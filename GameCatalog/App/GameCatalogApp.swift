//
//  GameCatalogApp.swift
//  GameCatalog
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import SwiftUI

@main
struct GameCatalogApp: App {
  let homePresenter = HomePresenter(homeUseCase: Injection.init().provideHome())
  let favoritePresenter = FavoritePresenter(favoriteUseCase: Injection.init().provideFavorite())
  let searchPresenter = Injection.init().provideSearchPresenter()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
        .environmentObject(favoritePresenter)
        .environmentObject(searchPresenter)
    }
  }
}
