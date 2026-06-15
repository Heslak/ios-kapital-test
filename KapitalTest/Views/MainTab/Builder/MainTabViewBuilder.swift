//
//  MainTabViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService
import NetworkService
import SwiftUI

// MARK: - Main Tab View Builder

struct MainTabViewBuilder {
    
    /// Builds the main tab container with shared app dependencies.
    /// - Parameters:
    ///   - networkService: Service passed to tab children that need remote synchronization.
    ///   - localStorageService: Service passed to tab children that need local persistence.
    ///   - coordinator: Coordinator shared by tab children for navigation.
    @ViewBuilder
    static func makeMainTabScreen(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface,
        coordinator: AppCoordinator
    ) -> some View {
        MainTabView(
            networkService: networkService,
            localStorageService: localStorageService,
            coordinator: coordinator
        )
    }
}
