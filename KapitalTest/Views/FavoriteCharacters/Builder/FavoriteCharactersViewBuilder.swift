//
//  FavoriteCharactersViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService
import SwiftUI

// MARK: - Favorite Characters View Builder

struct FavoriteCharactersViewBuilder {
    
    /// Builds the Favorite Characters screen dependency graph.
    /// - Parameters:
    ///   - localStorageService: Service used by the repository for local favorite reads and writes.
    ///   - coordinator: Coordinator used for navigation from favorites.
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
