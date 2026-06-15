//
//  CharacterDetailViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import LocalStorageService
import NetworkService

// MARK: - Character Detail View Builder

struct CharacterDetailViewBuilder {
    
    /// Builds the Character Detail screen dependency graph.
    /// - Parameters:
    ///   - characterId: Character identifier requested by navigation.
    ///   - networkService: Service used by the repository for remote synchronization.
    ///   - localStorageService: Service used by the repository for local persistence.
    ///   - coordinator: Coordinator used for navigation from detail.
    @ViewBuilder
    static func makeCharacterDetailScreen(
        characterId: Int,
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface,
        coordinator: AppCoordinator
    ) -> some View {
        let repository = CharacterDetailRepository(
            networkService: networkService,
            localStorageService: localStorageService
        )
        let useCase = FetchCharacterDetailUseCase(repository: repository)
        let viewModel = CharacterDetailViewModel(
            characterId: characterId,
            fetchCharacterDetailUseCase: useCase
        )
        
        CharacterDetailView(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
