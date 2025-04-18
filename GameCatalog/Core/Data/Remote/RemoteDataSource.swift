//
//  RemoteDataSource.swift
//  GameCatalog
//
//  Created by Gilang Ramadhan on 22/11/22.
//
//
//import Foundation
//import Alamofire
//import Combine
//
//protocol RemoteDataSourceProtocol: AnyObject {
//
//  func getCategories() -> AnyPublisher<[CategoryResponse], Error>
//  func getMeal(by id: String) -> AnyPublisher<MealResponse, Error>
//  func getMeals(by category: String) -> AnyPublisher<[MealResponse], Error>
//  func searchMeal(by title: String) -> AnyPublisher<[MealResponse], Error>
//  
//  func getGames(page: Int, pageSize: Int, search: String?) -> AnyPublisher<GamesResponse, Error>
//  func getGameDetail(by id: Int) -> AnyPublisher<GameDetailResponse, Error>
//
//}
//
//final class RemoteDataSource: NSObject {
//
//  private override init() { }
//
//  static let sharedInstance: RemoteDataSource =  RemoteDataSource()
//
//}
//
//extension RemoteDataSource: RemoteDataSourceProtocol {
//
//  func getGames(
//    page: Int = 1,
//    pageSize: Int = 10,
//    search: String? = nil
//  ) -> AnyPublisher<GamesResponse, Error> {
//    return Future<GamesResponse, Error> { completion in
//      var urlString = Endpoints.Gets.games.url
//      urlString += "&page=\(page)&page_size=\(pageSize)"
//      if let searchQuery = search {
//        urlString += "&search=\(searchQuery)"
//      }
//      
//      if let url = URL(string: urlString) {
//        AF.request(url)
//          .validate()
//          .responseDecodable(of: GamesResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//              completion(.success(value))
//            case .failure:
//              completion(.failure(URLError.invalidResponse))
//            }
//          }
//      }
//    }.eraseToAnyPublisher()
//  }
//  
//  func getGameDetail(
//    by id: Int
//  ) -> AnyPublisher<GameDetailResponse, Error> {
//    return Future<GameDetailResponse, Error> { completion in
//      if let url = URL(string: Endpoints.Gets.gameDetail(id: id).url) {
//        AF.request(url)
//          .validate()
//          .responseDecodable(of: GameDetailResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//              completion(.success(value))
//            case .failure:
//              completion(.failure(URLError.invalidResponse))
//            }
//          }
//      }
//    }.eraseToAnyPublisher()
//  }
//
//
//  func getCategories() -> AnyPublisher<[CategoryResponse], Error> {
//    return Future<[CategoryResponse], Error> { completion in
//      if let url = URL(string: Endpoints.Gets.categories.url) {
//        AF.request(url)
//          .validate()
//          .responseDecodable(of: CategoriesResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//              completion(.success(value.categories))
//            case .failure:
//              completion(.failure(URLError.invalidResponse))
//            }
//          }
//      }
//    }.eraseToAnyPublisher()
//  }
//
//  func getMeal(
//    by id: String
//  ) -> AnyPublisher<MealResponse, Error> {
//    return Future<MealResponse, Error> { completion in
//      if let url = URL(string: Endpoints.Gets.meal.url + id) {
//        AF.request(url)
//          .validate()
//          .responseDecodable(of: MealsResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//              completion(.success(value.meals[0]))
//            case .failure:
//              completion(.failure(URLError.invalidResponse))
//            }
//          }
//      }
//    }.eraseToAnyPublisher()
//  }
//
//  func getMeals(
//    by category: String
//  ) -> AnyPublisher<[MealResponse], Error> {
//    return Future<[MealResponse], Error> { completion in
//      if let url = URL(string: Endpoints.Gets.meals.url + category) {
//        AF.request(url)
//          .validate()
//          .responseDecodable(of: MealsResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//              completion(.success(value.meals))
//            case .failure:
//              completion(.failure(URLError.invalidResponse))
//            }
//          }
//      }
//    }.eraseToAnyPublisher()
//  }
//
//  func searchMeal(
//    by title: String
//  ) -> AnyPublisher<[MealResponse], Error> {
//    return Future<[MealResponse], Error> { completion in
//      if let url = URL(string: Endpoints.Gets.search.url + title) {
//        AF.request(url)
//          .validate()
//          .responseDecodable(of: MealsResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//              completion(.success(value.meals))
//            case .failure:
//              completion(.failure(URLError.invalidResponse))
//            }
//          }
//      }
//    }.eraseToAnyPublisher()
//  }
//}
