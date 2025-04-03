//
//  SearchView.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var presenter: SearchPresenter
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    var body: some View {
        VStack {
            searchBar
            
            if presenter.isLoading {
                loadingView
            } else if presenter.games.isEmpty && !searchText.isEmpty {
                emptyView
            } else {
                gamesList
            }
        }
        .navigationTitle("Search Games")
    }
}

extension SearchView {
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search games...", text: $searchText)
                .onSubmit {
                    if !searchText.isEmpty {
                        isSearching = true
                        presenter.searchGames(query: searchText)
                    }
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    presenter.games = []
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("Searching for games...")
                .padding(.top, 16)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    var emptyView: some View {
        VStack {
            Spacer()
            Image(systemName: "gamecontroller")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No games found")
                .font(.title2)
                .padding(.top, 8)
            Text("Try a different search term")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    var gamesList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(presenter.games) { game in
                    NavigationLink(destination: DetailView(presenter: DetailPresenter(detailUseCase: Injection.init().provideDetail(gameId: game.id)))) {
                        // Use your existing GameRow without the onFavoriteToggle parameter
                        GameRow(game: game)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 8)
        }
    }
}
