//
//  APICall.swift
//  GameCatalog
//
//  Created by Gilang Ramadhan on 22/11/22.
//

import Foundation

struct API {

  static let mealBaseUrl = "https://www.themealdb.com/api/json/v1/1/"
  static let gameBaseUrl = "https://api.rawg.io/api/"
  static let gameApiKey = "fe9d7ddef6394a068e8f6aa7675aacd6"

}

protocol Endpoint {

  var url: String { get }

}

enum Endpoints {

  enum Gets: Endpoint {
    case categories
    case meals
    case meal
    case search
    case games
    case gameDetail(id: Int)

    public var url: String {
      switch self {
      case .categories: return "\(API.mealBaseUrl)categories.php"
      case .meals: return "\(API.mealBaseUrl)filter.php?c="
      case .meal: return "\(API.mealBaseUrl)lookup.php?i="
      case .search: return "\(API.mealBaseUrl)search.php?s="
      case .games: return "\(API.gameBaseUrl)games?key=\(API.gameApiKey)&page_size=20&page=1"
      case .gameDetail(let id): return "\(API.gameBaseUrl)games/\(id)?key=\(API.gameApiKey)"
      }
    }
  }

}
