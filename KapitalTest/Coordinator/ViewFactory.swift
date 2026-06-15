//
//  ViewFactory.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import NetworkService
import LocalStorageService

// MARK: - View Factory Protocol

/// Protocol that defines the contract for creating views.
/// Separating view creation from navigation allows better testability.
protocol ViewFactoryProtocol {
    associatedtype HomeScreen: View
    associatedtype DetailScreen: View
    
    /// Creates the main tab screen containing Home and Favorites tabs.
    /// - Parameter coordinator: Coordinator for handling navigation actions.
    func makeHomeScreen(coordinator: AppCoordinator) -> HomeScreen
    
    /// Creates the character detail screen.
    /// - Parameters:
    ///   - characterId: The ID of the character to display.
    ///   - coordinator: Coordinator for handling navigation actions.
    func makeDetailScreen(characterId: Int, coordinator: AppCoordinator) -> DetailScreen
}

// MARK: - App View Factory

/// Concrete implementation of ViewFactory that creates all app screens.
/// Uses dependency injection to provide services to each screen.
final class AppViewFactory: ViewFactoryProtocol {
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    
    /// Creates the factory with the required services.
    /// - Parameters:
    ///   - networkService: Service for network requests.
    ///   - localStorageService: Service for local data persistence.
    init(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface
    ) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    /// Creates the main tab screen with Home and Favorites tabs.
    @ViewBuilder
    func makeHomeScreen(coordinator: AppCoordinator) -> some View {
        MainTabViewBuilder.makeMainTabScreen(
            networkService: networkService,
            localStorageService: localStorageService,
            coordinator: coordinator
        )
    }
    
    /// Creates the character detail screen for a specific character.
    @ViewBuilder
    func makeDetailScreen(characterId: Int, coordinator: AppCoordinator) -> some View {
        CharacterDetailViewBuilder.makeCharacterDetailScreen(
            characterId: characterId,
            networkService: networkService,
            localStorageService: localStorageService,
            coordinator: coordinator
        )
    }
}
