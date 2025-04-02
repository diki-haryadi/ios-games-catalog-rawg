//
//  DetailRouter.swift
//  TheMealsApp
//
//  Created by Gilang Ramadhan on 29/11/22.
//

import SwiftUI

class DetailRouter {

    func makeGameDetailView(for gameId: Int) -> some View {
       let detailUseCase = Injection.init().provideDetail(gameId: gameId)
       let presenter = DetailPresenter(detailUseCase: detailUseCase)
       return DetailView(presenter: presenter)
     }

}
