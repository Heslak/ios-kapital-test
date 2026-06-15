//
//  MainTabView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import DesignSystem
import LocalStorageService
import NetworkService
import SwiftUI

struct MainTabView: View {
    let networkService: NetworkServiceInterface
    let localStorageService: LocalStorageServiceInterface
    
    @State private var selectedTab: MainTab = .characters
    @ObservedObject private var coordinator: AppCoordinator
    
    init(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface,
        coordinator: AppCoordinator
    ) {
        self.networkService = networkService
        self.localStorageService = localStorageService
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeViewBuilder.makeHomeScreen(
                networkService: networkService,
                localStorageService: localStorageService,
                coordinator: coordinator
            )
            .tabItem {
                Label(AppStrings.charactersTitle, systemImage: "list.bullet")
            }
            .tag(MainTab.characters)
            
            FavoriteCharactersViewBuilder.makeFavoriteCharactersScreen(
                localStorageService: localStorageService,
                coordinator: coordinator
            )
            .tabItem {
                Label(AppStrings.favoritesTitle, systemImage: "suit.heart.fill")
            }
            .tag(MainTab.favorites)
        }
        .tint(Color(.ink(.favorite)))
    }
}

private enum MainTab: Hashable {
    case characters
    case favorites
}
