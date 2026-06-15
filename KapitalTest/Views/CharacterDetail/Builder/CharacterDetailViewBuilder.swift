//
//  CharacterDetailViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import LocalStorageService
import NetworkService

struct CharacterDetailViewBuilder {
    
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
