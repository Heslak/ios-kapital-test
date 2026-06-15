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

// MARK: - App Coordinator

final class AppCoordinator: ObservableObject {
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    @Published var path = NavigationPath()
    
    /// Creates the coordinator with injectable app-wide dependencies.
    /// - Parameters:
    ///   - networkService: Service used by repositories to execute remote requests.
    ///   - localStorageService: Service used by repositories to read and persist local data.
    ///   - path: Initial navigation path, mainly useful for tests or deep links.
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
    
    /// Pushes a new route into the navigation stack.
    /// - Parameter route: Route to display.
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    /// Removes the top route from the stack when possible.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Clears the stack and returns to the root screen.
    func popToRoot() {
        path = NavigationPath()
    }
    
    // MARK: - View Factory
    
    /// Builds the SwiftUI screen for a route and injects the dependencies it needs.
    /// - Parameter route: Route requested by navigation.
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
