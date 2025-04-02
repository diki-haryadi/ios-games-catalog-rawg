//
//  GameMapper.swift
//  TheMealsApp
//
//  Created by Ben on 29/11/22.
//

import Foundation

final class GameMapper {
  static func mapGameResponsesToEntities(
    input gameResponses: [GameResponse]
  ) -> [GameEntity] {
    return gameResponses.map { result in
      let newGame = GameEntity()
      newGame.id = result.id
      newGame.slug = result.slug
      newGame.name = result.name
      newGame.released = result.released ?? "Unknown"
      newGame.backgroundImage = result.backgroundImage ?? "Unknown"
      newGame.rating = result.rating
      newGame.ratingTop = result.ratingTop
      newGame.ratingsCount = result.ratingsCount
      newGame.metacritic = result.metacritic ?? 0
      newGame.playtime = result.playtime
      newGame.updated = result.updated
      return newGame
    }
  }

  static func mapGameResponsesToDomains(
    input gameResponses: [GameResponse]
  ) -> [GameModel] {
    return gameResponses.map { result in
      return GameModel(
        id: result.id,
        slug: result.slug,
        name: result.name,
        released: result.released ?? "Unknown",
        backgroundImage: result.backgroundImage ?? "Unknown",
        rating: result.rating,
        ratingTop: result.ratingTop,
        ratingsCount: result.ratingsCount,
        metacritic: result.metacritic ?? 0,
        playtime: result.playtime,
        updated: result.updated
      )
    }
  }

  static func mapGameEntitiesToDomains(
    input gameEntities: [GameEntity]
  ) -> [GameModel] {
    return gameEntities.map { result in
      return GameModel(
        id: result.id,
        slug: result.slug,
        name: result.name,
        released: result.released,
        backgroundImage: result.backgroundImage,
        rating: result.rating,
        ratingTop: result.ratingTop,
        ratingsCount: result.ratingsCount,
        metacritic: result.metacritic,
        playtime: result.playtime,
        updated: result.updated,
        description: result.gameDescription,
        nameOriginal: result.nameOriginal,
        tba: result.tba,
        screenshotsCount: result.screenshotsCount,
        moviesCount: result.moviesCount,
        creatorsCount: result.creatorsCount,
        achievementsCount: result.achievementsCount,
        parentAchievementsCount: result.parentAchievementsCount,
        redditUrl: result.redditUrl,
        redditName: result.redditName,
        website: result.website,
        metacriticUrl: result.metacriticUrl,
        favorite: result.favorite
      )
    }
  }

  static func mapDetailGameEntityToDomain(
    input gameEntity: GameEntity
  ) -> GameModel {
    return GameModel(
      id: gameEntity.id,
      slug: gameEntity.slug,
      name: gameEntity.name,
      released: gameEntity.released,
      backgroundImage: gameEntity.backgroundImage,
      rating: gameEntity.rating,
      ratingTop: gameEntity.ratingTop,
      ratingsCount: gameEntity.ratingsCount,
      metacritic: gameEntity.metacritic,
      playtime: gameEntity.playtime,
      updated: gameEntity.updated,
      description: gameEntity.gameDescription,
      nameOriginal: gameEntity.nameOriginal,
      tba: gameEntity.tba,
      screenshotsCount: gameEntity.screenshotsCount,
      moviesCount: gameEntity.moviesCount,
      creatorsCount: gameEntity.creatorsCount,
      achievementsCount: gameEntity.achievementsCount,
      parentAchievementsCount: gameEntity.parentAchievementsCount,
      redditUrl: gameEntity.redditUrl,
      redditName: gameEntity.redditName,
      website: gameEntity.website,
      metacriticUrl: gameEntity.metacriticUrl,
      favorite: gameEntity.favorite
    )
  }

  static func mapDetailGameResponseToEntity(
    input gameResponse: GameDetailResponse
  ) -> GameEntity {
    let gameEntity = GameEntity()
    gameEntity.id = gameResponse.id
    gameEntity.slug = gameResponse.slug
    gameEntity.name = gameResponse.name
    gameEntity.nameOriginal = gameResponse.nameOriginal
    gameEntity.gameDescription = gameResponse.description
    gameEntity.metacritic = gameResponse.metacritic ?? 0
    gameEntity.released = gameResponse.released ?? "Unknown"
    gameEntity.tba = gameResponse.tba
    gameEntity.backgroundImage = gameResponse.backgroundImage ?? "Unknown"
    gameEntity.rating = gameResponse.rating
    gameEntity.ratingTop = gameResponse.ratingTop
    gameEntity.playtime = gameResponse.playtime
    gameEntity.screenshotsCount = gameResponse.screenshotsCount
    gameEntity.moviesCount = gameResponse.moviesCount
    gameEntity.creatorsCount = gameResponse.creatorsCount
    gameEntity.achievementsCount = gameResponse.achievementsCount
    gameEntity.parentAchievementsCount = gameResponse.parentAchievementsCount
    gameEntity.redditUrl = gameResponse.redditUrl ?? ""
    gameEntity.redditName = gameResponse.redditName ?? ""
    gameEntity.website = gameResponse.website ?? ""
    gameEntity.metacriticUrl = gameResponse.metacriticUrl ?? ""
    return gameEntity
  }

  static func mapGamesResponseToModels(
    input gamesResponse: GamesResponse
  ) -> [GameModel] {
    return mapGameResponsesToDomains(input: gamesResponse.results)
  }

  static func mapGameDetailResponseToModel(
    input gameDetailResponse: GameDetailResponse
  ) -> GameDetailModel {
    let gameEntity = mapDetailGameResponseToEntity(input: gameDetailResponse)
    return GameDetailModel(
      id: gameEntity.id,
      slug: gameEntity.slug,
      name: gameEntity.name,
      nameOriginal: gameEntity.nameOriginal,
      description: gameEntity.gameDescription,
      metacritic: gameEntity.metacritic,
      released: gameEntity.released,
      tba: gameEntity.tba,
      backgroundImage: gameEntity.backgroundImage,
      rating: gameEntity.rating,
      ratingTop: gameEntity.ratingTop,
      playtime: gameEntity.playtime,
      screenshotsCount: gameEntity.screenshotsCount,
      moviesCount: gameEntity.moviesCount,
      creatorsCount: gameEntity.creatorsCount,
      achievementsCount: gameEntity.achievementsCount,
      parentAchievementsCount: gameEntity.parentAchievementsCount,
      redditUrl: gameEntity.redditUrl,
      redditName: gameEntity.redditName,
      website: gameEntity.website,
      metacriticUrl: gameEntity.metacriticUrl
    )
  }
}
