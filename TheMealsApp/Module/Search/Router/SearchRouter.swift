//
//  SearchRouter.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 29/11/22.
//

import SwiftUI

class SearchRouter {

    func makeMealView(for meal: MealModel, game: GameModel) -> some View {
        let mealUseCase = Injection.init().provideMeal(meal: meal, game: game)
        let presenter = MealPresenter(mealUseCase: mealUseCase)
        return MealView(presenter: presenter)
  }

}
