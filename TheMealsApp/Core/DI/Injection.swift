//
//  Injection.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 22/11/22.
//  Updated on 03/04/25.
//

import Foundation
import RealmSwift

final class Injection: NSObject {

  private func provideRepository() -> GameRepositoryProtocol {
    let realm = try? Realm()

    let locale: LocaleGameDataSource = LocaleGameDataSource.sharedInstance(realm)
    let remote: RemoteGameDataSource = RemoteGameDataSource.sharedInstance

    return GameRepository.sharedInstance(locale, remote)
  }

  func provideHome() -> HomeUseCase {
    let repository = provideRepository()
    return HomeInteractor(repository: repository)
  }

  func provideDetail(gameId: Int) -> DetailUseCase {
    let repository = provideRepository()
    return DetailInteractor(repository: repository, gameId: gameId)
  }

  func provideSearch() -> SearchUseCase {
    let repository = provideRepository()
    return SearchInteractor(repository: repository)
  }

  func provideFavorite() -> FavoriteUseCase {
    let repository = provideRepository()
    return FavoriteInteractor(repository: repository)
  }
}
