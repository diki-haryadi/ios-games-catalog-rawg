//
//  GameModel.swift
//  GameCatalog
//
//  Created on 03/04/25.
//

import Foundation

struct GameModel: Equatable, Identifiable {
    let id: Int
    let name: String
    let released: String
    let backgroundImage: String
    let rating: Double
    let ratingCount: Int
    let description: String
    let genres: [String]
    let platforms: [String]
    var isFavorite: Bool
    
    // Computed property to handle empty or invalid image URLs
    var validBackgroundImageURL: URL? {
        // Ensure the URL string is not empty
        guard !backgroundImage.isEmpty else {
            return nil
        }
        
        // Check if the URL is valid
        if let url = URL(string: backgroundImage) {
            return url
        }
        
        // If the URL has special characters that need encoding
        if let encodedURLString = backgroundImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            return url
        }
        
        return nil
    }
    
    // Helper to get a default placeholder if no image is available
    var imageURLOrPlaceholder: URL {
        return validBackgroundImageURL ?? URL(string: "https://via.placeholder.com/600x400?text=No+Image")!
    }
}
