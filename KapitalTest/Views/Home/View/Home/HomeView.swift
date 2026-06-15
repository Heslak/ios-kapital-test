//
//  HomeView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import SwiftUI
import DesignSystem

struct HomeView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: HomeViewModel
    
    init(
        viewModel: HomeViewModel,
        coordinator: AppCoordinator,
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        contentView
            .background(.background(.standard))
            .task {
                await fetchUsers()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if let charactersList = viewModel.charactersList {
            buildCharactersListView(with: charactersList)
        } else if viewModel.state == .error {
            errorView
        } else {
            loadingView
        }
    }
    
    @ViewBuilder
    private func buildCharactersListView(with charactersList: CharactersList) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: DSDimens.spacing_5) {
                HomeTitleView(
                    title: AppStrings.appEyebrow,
                    subtitle: AppStrings.charactersTitle
                )
                            
                Text(AppStrings.allCharactersTitle)
                    .font(.h2Bold)
                    .foregroundStyle(.ink(.primary))
                
                ForEach(charactersList.data, id: \.id) { character in
                    CharacterListCell(
                        character: character,
                        favoriteAction: toggleFavorite
                    )
                    .onTapGesture {
                        showDetail(for: character)
                    }
                    .task {
                        await loadNextPageIfNeeded(for: character)
                    }
                }
                
                if viewModel.state == .loading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(DSDimens.spacing_5)
        }
    }
    
    private var loadingView: some View {
        LoadingView()
    }
    
    private var errorView: some View {
        ErrorView {
            await fetchUsers()
        }
    }
    
    private func fetchUsers() async {
        await viewModel.fetchUsers()
    }
    
    private func loadNextPageIfNeeded(for character: CharacterInfo) async {
        await viewModel.loadNextPageIfNeeded(
            currentCharacter: character
        )
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
    HomeView(
        viewModel: HomeViewModel(fetchUsersUseCase: FetchUsersUseCaseMock()),
        coordinator: AppCoordinator()
    )
}
#endif
