//
//  HomeViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI
import NetworkService
import LocalStorageService

// MARK: - Home View Builder

struct HomeViewBuilder {
    
    /// Builds the Home screen dependency graph.
    /// - Parameters:
    ///   - networkService: Service used by the repository for remote synchronization.
    ///   - localStorageService: Service used by the repository for local persistence.
    ///   - coordinator: Coordinator used for navigation from Home.
    @MainActor
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
