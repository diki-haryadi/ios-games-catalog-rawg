//
//  ContentView.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    TabView {
      NavigationView {
        HomeView(
          presenter: HomePresenter(
            homeUseCase: Injection.init().provideHome()
          )
        )
      }
      .tabItem {
        Image(systemName: "gamecontroller")
        Text("Games")
      }
      
        NavigationView {
            SearchView(
                presenter: Injection.init().provideSearchPresenter()
            )
        }
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
      
      NavigationView {
        FavoriteView(
          presenter: FavoritePresenter(
            favoriteUseCase: Injection.init().provideFavorite()
          )
        )
      }
      .tabItem {
        Image(systemName: "heart")
        Text("Favorites")
      }
    }
    .accentColor(.red)
  }
}

class AppState: ObservableObject {
  @Published var selectedTab: Int = 0
  @Published var needsRefreshFavorites: Bool = false
  
  static let shared = AppState()
}
