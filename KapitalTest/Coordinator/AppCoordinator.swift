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

// MARK: - Coordinator Protocol

/// Protocol defining navigation capabilities.
/// Allows creating mock coordinators for testing.
protocol CoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
}

// MARK: - App Coordinator

/// Manages navigation state and delegates view creation to the ViewFactory.
/// Single responsibility: navigation only, view creation is delegated.
final class AppCoordinator: CoordinatorProtocol {
    private let viewFactory: AppViewFactory
    @Published var path: NavigationPath
    
    /// Creates the coordinator with injectable app-wide dependencies.
    /// - Parameters:
    ///   - networkService: Service used by repositories to execute remote requests.
    ///   - localStorageService: Service used by repositories to read and persist local data.
    ///   - path: Initial navigation path, mainly useful for tests or deep links.
    init(
        networkService: NetworkServiceInterface = NetworkServiceFactory.makeNetworkService(),
        localStorageService: LocalStorageServiceInterface = LocalStorageServiceFactory.makeLocalStorageService(),
        path: NavigationPath = NavigationPath()
    ) {
        self.path = path
        self.viewFactory = AppViewFactory(
            networkService: networkService,
            localStorageService: localStorageService
        )
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
    
    // MARK: - View Building
    
    /// Builds the SwiftUI screen for a route using the ViewFactory.
    /// - Parameter route: Route requested by navigation.
    @MainActor
    @ViewBuilder
    func buildView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            viewFactory.makeHomeScreen(coordinator: self)
        case .detail(let id):
            viewFactory.makeDetailScreen(characterId: id, coordinator: self)
        }
    }
}

