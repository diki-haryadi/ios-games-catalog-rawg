//
//  GameMapper.swift
//  TheMealsApp
//
//  Created on 03/04/25.
//

import Foundation
import RealmSwift

final class GameMapper {
    
    static func mapGameResponsesToDomainModels(
        input gameResponses: [GameResponse]
    ) -> [GameModel] {
        let mappedModels = gameResponses.map { mapGameResponseToDomainModel(input: $0) }
        
        // Log mapping results for debugging
        print("📊 Mapped \(mappedModels.count) games")
        if let firstGame = mappedModels.first {
            print("📸 First game mapped image URL: \(firstGame.backgroundImage)")
            print("📸 Is valid URL: \(firstGame.validBackgroundImageURL != nil ? "Yes" : "No")")
        }
        
        return mappedModels
    }
    
    static func mapGameResponseToDomainModel(
        input response: GameResponse,
        isFavorite: Bool = false
    ) -> GameModel {
        // Handle optional arrays with nil coalescing
        let genreNames = response.genres?.map { $0.name } ?? []
        let platformNames = response.platforms?.map { $0.platform.name } ?? []
        
        // Properly handle the background image URL
        let backgroundImageURL = response.backgroundImage ?? ""
        
        // Log the background image URL for this specific game
        print("🎮 Mapping game: \(response.name)")
        print("📸 Original background image: \(response.backgroundImage ?? "nil")")
        
        return GameModel(
            id: response.id,
            name: response.name,
            released: response.released ?? "Unknown",
            backgroundImage: backgroundImageURL,
            rating: response.rating,
            ratingCount: response.ratingsCount ?? 0,
            description: response.description ?? "No description available",
            genres: genreNames,
            platforms: platformNames,
            isFavorite: isFavorite
        )
    }
    
    static func mapDetailResponseToDomainModel(
        input response: GameDetailResponse,
        isFavorite: Bool = false
    ) -> GameModel {
        // For non-optional arrays in GameDetailResponse
        let genreNames = response.genres.map { $0.name }
        let platformNames = response.platforms.map { $0.platform.name }
        
        // Properly handle the background image URL
        let backgroundImageURL = response.backgroundImage ?? ""
        
        // Log the background image URL for this specific game detail
        print("🎮 Mapping game detail: \(response.name)")
        print("📸 Original background image: \(response.backgroundImage ?? "nil")")
        
        return GameModel(
            id: response.id,
            name: response.name,
            released: response.released ?? "Unknown",
            backgroundImage: backgroundImageURL,
            rating: response.rating,
            ratingCount: response.ratingsCount ?? 0,
            description: response.description ?? "No description available",
            genres: genreNames,
            platforms: platformNames,
            isFavorite: isFavorite
        )
    }
    
    static func mapGameEntitiesToDomainModels(
        input gameEntities: [GameEntity]
    ) -> [GameModel] {
        return gameEntities.map { mapGameEntityToDomainModel(input: $0) }
    }
    
    static func mapGameEntityToDomainModel(
        input entity: GameEntity
    ) -> GameModel {
        return GameModel(
            id: entity.id,
            name: entity.name,
            released: entity.released,
            backgroundImage: entity.backgroundImage,
            rating: entity.rating,
            ratingCount: entity.ratingCount,
            description: entity.desc,
            genres: Array(entity.genres),
            platforms: Array(entity.platforms),
            isFavorite: true
        )
    }
    
    static func mapGameModelToEntity(
        input model: GameModel
    ) -> GameEntity {
        let entity = GameEntity()
        entity.id = model.id
        entity.name = model.name
        entity.released = model.released
        entity.backgroundImage = model.backgroundImage
        entity.rating = model.rating
        entity.ratingCount = model.ratingCount
        entity.desc = model.description
        
        let genresList = List<String>()
        model.genres.forEach { genresList.append($0) }
        entity.genres = genresList
        
        let platformsList = List<String>()
        model.platforms.forEach { platformsList.append($0) }
        entity.platforms = platformsList
        
        return entity
    }
}
