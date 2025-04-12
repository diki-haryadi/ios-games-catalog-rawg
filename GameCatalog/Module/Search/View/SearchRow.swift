//
//  GameRow.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import SwiftUI
import CachedAsyncImage

struct SearchRow: View {
    var game: GameModel
    var onFavoriteToggle: ((Bool) -> Void)? = nil

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                gameImage
                content
                Spacer()
                favoriteButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Divider()
                .padding(.leading)
        }
    }
    
    var gameImage: some View {
        CachedAsyncImage(url: URL(string: game.backgroundImage)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
                .overlay(
                    Image(systemName: "gamecontroller")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
        }
        .frame(width: 120, height: 80)
        .cornerRadius(10)
        .clipped()
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(game.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .lineLimit(2)
            
            if !game.released.isEmpty && game.released != "Unknown" {
                Text("Released: \(formattedDate(game.released))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 12))
                
                Text(String(format: "%.1f", game.rating))
                    .font(.system(size: 14, weight: .medium))
                
                Text("(\(game.ratingCount))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            if !game.genres.isEmpty {
                genresList
            }
        }
        .padding(.leading, 8)
    }
    
    var genresList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(game.genres.prefix(3), id: \.self) { genre in
                    Text(genre)
                        .font(.system(size: 12))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                if game.genres.count > 3 {
                    Text("+\(game.genres.count - 3)")
                        .font(.system(size: 12))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .frame(height: 30)
    }
    
    var favoriteButton: some View {
        Button(action: {
            onFavoriteToggle?(!game.isFavorite)
        }) {
            Image(systemName: game.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(game.isFavorite ? .red : .gray)
                .font(.title3)
                .padding(8)
        }
    }
    
    // Helper function to format the date
    func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d, yyyy"
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}
