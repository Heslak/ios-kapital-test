//
//  FavoriteCharactersViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService
import SwiftUI

struct FavoriteCharactersViewBuilder {
    
    @ViewBuilder
    static func makeFavoriteCharactersScreen(
        localStorageService: LocalStorageServiceInterface,
        coordinator: AppCoordinator
    ) -> some View {
        let repository = FavoriteCharactersRepository(
            localStorageService: localStorageService
        )
        let useCase = FetchFavoriteCharactersUseCase(repository: repository)
        let viewModel = FavoriteCharactersViewModel(
            fetchFavoriteCharactersUseCase: useCase
        )
        
        FavoriteCharactersView(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
