//
//  GameResponseModels.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation

struct GamesListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [GameResponse]
}

struct GameDetailResponse: Decodable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingsCount: Int?
    let description: String?
    let genres: [GenreResponse]
    let platforms: [PlatformWrapper]
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, rating, genres, platforms
        case backgroundImage = "background_image"
        case ratingsCount = "ratings_count"
        case description = "description_raw"
    }
}

struct GameResponse: Decodable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingsCount: Int?
    let description: String?
    let genres: [GenreResponse]?
    let platforms: [PlatformWrapper]?
    let tags: [TagResponse]?
    let metacritic: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, rating, genres, platforms, tags, metacritic
        case backgroundImage = "background_image"
        case ratingsCount = "ratings_count"
        case description = "description_raw"
    }
    
    // Custom initializer to help with debugging missing or incorrect fields
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode required fields and log any errors
        id = try container.decode(Int.self, forKey: .id)
        slug = try container.decode(String.self, forKey: .slug)
        name = try container.decode(String.self, forKey: .name)
        
        // Decode optional fields with better logging
        do {
            backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
            print("📸 Decoded backgroundImage for \(name): \(backgroundImage ?? "nil")")
        } catch {
            print("⚠️ Error decoding backgroundImage for \(name): \(error)")
            backgroundImage = nil
        }
        
        released = try container.decodeIfPresent(String.self, forKey: .released)
        rating = try container.decode(Double.self, forKey: .rating)
        ratingsCount = try container.decodeIfPresent(Int.self, forKey: .ratingsCount)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        genres = try container.decodeIfPresent([GenreResponse].self, forKey: .genres)
        platforms = try container.decodeIfPresent([PlatformWrapper].self, forKey: .platforms)
        tags = try container.decodeIfPresent([TagResponse].self, forKey: .tags)
        metacritic = try container.decodeIfPresent(Int.self, forKey: .metacritic)
    }
}

struct GenreResponse: Decodable {
    let id: Int
    let name: String
    let slug: String?
}

struct PlatformWrapper: Decodable {
    let platform: PlatformResponse
}

struct PlatformResponse: Decodable {
    let id: Int
    let name: String
    let slug: String?
}

struct TagResponse: Decodable {
    let id: Int
    let name: String
    let slug: String?
}
