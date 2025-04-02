//
//  SearchView.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
  
  @ObservedObject var presenter: SearchPresenter
  
  var body: some View {
    ZStack {
      VStack {
        searchBar
        
        if presenter.isLoading {
          loadingIndicator
        } else if presenter.isError {
          errorIndicator
        } else if presenter.games.isEmpty && !presenter.searchQuery.isEmpty {
          emptyGames
        } else if !presenter.games.isEmpty {
          gameList
        } else {
          startSearching
        }
      }
    }
    .navigationBarTitle(
      Text("Search Games"),
      displayMode: .automatic
    )
  }
  
  var searchBar: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
      
      TextField("Search for games...", text: $presenter.searchQuery)
        .disableAutocorrection(true)
      
      if !presenter.searchQuery.isEmpty {
        Button(action: {
          presenter.searchQuery = ""
          presenter.games = []
        }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(10)
    .padding()
  }
}

extension SearchView {
  var loadingIndicator: some View {
    VStack {
      Spacer()
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      Text("Searching...")
        .padding(.top, 8)
      Spacer()
    }
  }
  
  var errorIndicator: some View {
    CustomEmptyView(
      image: "assetSearchNotFound",
      title: presenter.errorMessage
    )
  }
  
  var emptyGames: some View {
    CustomEmptyView(
      image: "assetSearchNotFound",
      title: "No games found matching '\(presenter.searchQuery)'"
    )
  }
  
  var startSearching: some View {
    VStack {
      Spacer()
      Image(systemName: "magnifyingglass")
        .font(.system(size: 85))
        .foregroundColor(.gray)
      Text("Search for your favorite games")
        .font(.title3)
        .foregroundColor(.gray)
        .padding()
      Spacer()
    }
  }
  
  var gameList: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(presenter.games) { game in
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
