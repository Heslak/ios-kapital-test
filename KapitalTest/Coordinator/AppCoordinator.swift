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

final class AppCoordinator: ObservableObject {
    private let networkService: NetworkServiceInterface    
    @Published var path = NavigationPath()
    
    init(
        networkService: NetworkServiceInterface = NetworkFactory.makeNetworkService(),
        path: NavigationPath = NavigationPath(),
    ) {
        self.path = path
        self.networkService = networkService
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
            HomeViewBuilder.makeHomeScreen(
                networkClient: networkService,
                coordinator: self
            )
        case .detail(let item):
            EmptyView()
        }
    }
}
