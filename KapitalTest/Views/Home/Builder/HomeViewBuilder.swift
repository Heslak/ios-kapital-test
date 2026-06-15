//
//  HomeViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI
import NetworkService
import LocalStorageService

struct HomeViewBuilder {
    
    @ViewBuilder
    static func makeHomeScreen(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface,
        coordinator: AppCoordinator
    ) -> some View {
        let repository = HomeRepository(
            networkService: networkService,
            localStorageService: localStorageService
        )
        let useCase = FetchUsersUseCase(repository: repository)
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        HomeView(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
