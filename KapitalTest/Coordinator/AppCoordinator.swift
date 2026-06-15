//
//  AppCoordinator.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation
import SwiftUI
import Combine
import NetworkService
import LocalStorageService

final class AppCoordinator: ObservableObject {
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    @Published var path = NavigationPath()
    
    init(
        networkService: NetworkServiceInterface = NetworkServiceFactory.makeNetworkService(),
        localStorageService: LocalStorageServiceInterface = LocalStorageServiceFactory.makeLocalStorageService(),
        path: NavigationPath = NavigationPath(),
    ) {
        self.path = path
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    // MARK: - Navigation Actions
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    // MARK: - View Factory
    // Centralizes view generation and dependency injection
    @ViewBuilder
    func buildView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            MainTabViewBuilder.makeMainTabScreen(
                networkService: networkService,
                localStorageService: localStorageService,
                coordinator: self
            )
        case .detail(let id):
            CharacterDetailViewBuilder.makeCharacterDetailScreen(
                characterId: id,
                networkService: networkService,
                localStorageService: localStorageService,
                coordinator: self
            )
        }
    }
}
