//
//  HomeViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI
import NetworkService

struct HomeViewBuilder {
    
    @ViewBuilder
    static func makeHomeScreen(
        networkClient: NetworkServiceInterface,
        coordinator: AppCoordinator
    ) -> some View {
        let repository = HomeRepository(networkService: networkClient)
        let useCase = FetchUsersUseCase(repository: repository)
        let viewModel = HomeViewModel(fetchUsersUseCase: useCase)
        
        HomeView(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
