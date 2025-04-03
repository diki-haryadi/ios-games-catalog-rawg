//
//  HomeView.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI
import SDWebImageSwiftUI
import CachedAsyncImage

struct HomeView: View {
  
  @ObservedObject var presenter: HomePresenter
  
  var body: some View {
    ZStack {
      if presenter.isLoading {
        loadingIndicator
      } else if presenter.isError {
        errorIndicator
      } else if presenter.games.isEmpty {
        emptyGames
      } else {
        content
      }
    }.onAppear {
      self.presenter.getGames()
    }.navigationBarTitle(
      Text("Game Catalog"),
      displayMode: .automatic
    )
  }
}

extension HomeView {
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
  
  var emptyGames: some View {
    CustomEmptyView(
      image: "assetNoData",
      title: "No games found"
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

struct GameRow: View {
  var game: GameModel
  
  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      WebImage(url: URL(string: game.backgroundImage))
        .resizable()
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
        .scaledToFill()
        .frame(width: 120, height: 80)
        .cornerRadius(8)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(game.name)
          .font(.headline)
          .lineLimit(2)
        
        Text("Released: \(game.released)")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text(String(format: "%.1f", game.rating))
          Text("(\(game.ratingCount))")
            .foregroundColor(.secondary)
        }
        .font(.subheadline)
        
        if !game.genres.isEmpty {
          Text(game.genres.prefix(3).joined(separator: ", "))
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
        }
      }
      
      Spacer()
      
      if game.isFavorite {
        Image(systemName: "heart.fill")
          .foregroundColor(.red)
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
}
