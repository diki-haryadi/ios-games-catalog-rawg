//
//  FavoriteView.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteView: View {
  
  @ObservedObject var presenter: FavoritePresenter
  
  var body: some View {
    ZStack {
      if presenter.isLoading {
        loadingIndicator
      } else if presenter.isError {
        errorIndicator
      } else if presenter.games.isEmpty {
        emptyFavorites
      } else {
        content
      }
    }
    .onAppear {
      self.presenter.getFavoriteGames()
    }
    .navigationBarTitle(
      Text("Favorite Games"),
      displayMode: .automatic
    )
  }
}

extension FavoriteView {
  var loadingIndicator: some View {
    VStack {
      Text("Loading...")
      ProgressView()
    }
  }
  
  var errorIndicator: some View {
    CustomEmptyView(
      image: "assetSearchNotFound",
      title: presenter.errorMessage
    ).offset(y: 80)
  }
  
  var emptyFavorites: some View {
    CustomEmptyView(
      image: "assetNoFavorite",
      title: "Your favorite games list is empty"
    ).offset(y: 80)
  }
  
  var content: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVStack(spacing: 16) {
        ForEach(self.presenter.games) { game in
          ZStack {
            self.presenter.linkBuilder(for: game.id) {
              GameRow(game: game)
            }
            .buttonStyle(PlainButtonStyle())
          }
          .padding(.horizontal)
        }
      }
      .padding(.vertical)
    }
  }
}
