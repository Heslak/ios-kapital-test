//
//  FavoriteCharactersView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import DesignSystem
import SwiftUI

struct FavoriteCharactersView: View {
    @StateObject private var viewModel: FavoriteCharactersViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    init(
        viewModel: FavoriteCharactersViewModel,
        coordinator: AppCoordinator
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        ZStack {
            contentView
        }
        .background(.background(.standard))
        .onAppear {
            viewModel.fetchFavoriteCharacters()
        }
        .onDisappear {
            viewModel.cancelFetch()
        }
        .transition(
            .opacity.animation(.smooth)
        )
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.state == .error {
            buildErrorView()
        } else if viewModel.characters.isEmpty {
            builEmptyView()
        } else {
            buildFavoriteCharactersList()
        }
    }
    
    private func buildFavoriteCharactersList() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: DSDimens.spacing_5) {
                HomeTitleView(
                    title: AppStrings.appEyebrow,
                    subtitle: AppStrings.favoritesTitle
                )
                .accessibilityIdentifier(AccessibilityIdentifiers.Favorites.screenTitle)
                
                ForEach(viewModel.characters, id: \.id) { character in
                    CharacterListCell(
                        character: character,
                        favoriteAction: toggleFavorite
                    )
                    .onTapGesture {
                        showDetail(for: character)
                    }
                }
            }
            .padding(DSDimens.spacing_5)
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.Favorites.charactersList)
    }
    
    private func builEmptyView() -> some View {
        EmptyView(
            title: AppStrings.appEyebrow,
            subtitle: AppStrings.favoritesTitle,
            descriptionTitle: AppStrings.noFavoritesTitle,
            description: AppStrings.noFavoritesDescription
        )
        .accessibilityIdentifier(AccessibilityIdentifiers.Favorites.emptyView)
        .accessibilityLabel(AccessibilityLabels.Favorites.emptyState)
    }
    
    private func buildErrorView() -> some View {
        ErrorView {
            await viewModel.fetchFavoriteCharacters()
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.Favorites.errorView)
        .accessibilityLabel(AccessibilityLabels.Common.error)
    }
    
    private func toggleFavorite(for character: CharacterInfo) {
        withAnimation(.smooth) {
            viewModel.toggleFavorite(for: character)
        }
    }
    
    private func showDetail(for character: CharacterInfo) {
        coordinator.push(.detail(id: character.id))
    }
}

#if DEBUG
#Preview {
    FavoriteCharactersView(
        viewModel: FavoriteCharactersViewModel(
            fetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseMock()
        ),
        coordinator: AppCoordinator()
    )
}
#endif
