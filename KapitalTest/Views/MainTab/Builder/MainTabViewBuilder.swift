//
//  MainTabViewBuilder.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService
import NetworkService
import SwiftUI

struct MainTabViewBuilder {
    
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
