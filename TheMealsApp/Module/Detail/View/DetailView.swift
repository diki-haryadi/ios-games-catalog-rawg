//
//  DetailView.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
  
  @ObservedObject var presenter: DetailPresenter
  
  var body: some View {
    ZStack {
      if presenter.isLoading {
        loadingIndicator
      } else if presenter.isError {
        errorIndicator
      } else if let game = presenter.game {
        ScrollView(.vertical, showsIndicators: true) {
          VStack(alignment: .leading, spacing: 16) {
            headerSection(game)
            
            Divider()
            
            descriptionSection(game)
            
            Divider()
            
            detailsSection(game)
          }
          .padding()
        }
      } else {
        emptyGame
      }
    }
    .navigationBarTitle(
      Text(presenter.game?.name ?? "Game Detail"),
      displayMode: .inline
    )
    .navigationBarItems(trailing: favoriteButton)
    .onAppear {
      self.presenter.getGameDetail()
    }
  }
  
  var favoriteButton: some View {
    Button(action: {
      self.presenter.updateFavoriteStatus()
    }) {
      Image(systemName: presenter.isFavorite ? "heart.fill" : "heart")
        .foregroundColor(presenter.isFavorite ? .red : .gray)
    }
  }
}

extension DetailView {
  
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
    )
  }
  
  var emptyGame: some View {
    CustomEmptyView(
      image: "assetNoData",
      title: "No game data available"
    )
  }
  
  func headerSection(_ game: GameModel) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      WebImage(url: URL(string: game.backgroundImage))
        .resizable()
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
        .scaledToFill()
        .frame(height: 200)
        .clipped()
        .cornerRadius(12)
      
      Text(game.name)
        .font(.title)
        .fontWeight(.bold)
      
      HStack {
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text(String(format: "%.1f", game.rating))
          Text("(\(game.ratingCount))")
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        Text("Released: \(game.released)")
          .foregroundColor(.secondary)
      }
      .font(.subheadline)
    }
  }
  
  func descriptionSection(_ game: GameModel) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Description")
        .font(.headline)
      
      Text(game.description)
        .font(.body)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  
  func detailsSection(_ game: GameModel) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      if !game.genres.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          Text("Genres")
            .font(.headline)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
              ForEach(game.genres, id: \.self) { genre in
                Text(genre)
                  .font(.caption)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(Color.gray.opacity(0.2))
                  .cornerRadius(16)
              }
            }
          }
        }
      }
      
      if !game.platforms.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          Text("Platforms")
            .font(.headline)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
              ForEach(game.platforms, id: \.self) { platform in
                Text(platform)
                  .font(.caption)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(Color.gray.opacity(0.2))
                  .cornerRadius(16)
              }
            }
          }
        }
      }
    }
  }
}
