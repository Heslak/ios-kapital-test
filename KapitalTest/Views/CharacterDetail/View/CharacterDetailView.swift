//
//  CharacterDetailView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    init(
        viewModel: CharacterDetailViewModel,
        coordinator: AppCoordinator
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        buildBodyView()
            .background(.background(.character))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: buildCharacterFavoriteView())
            .navigationBarItems(leading: builBackButton())
            .task {
                await fetchCharacter()
            }
    }
    
    @ViewBuilder
    func buildBodyView() -> some View {
        if let character = viewModel.character {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: DSDimens.spacing_5) {
                    CharacterDetailHeaderView(character: character)
                    CharacterDetailStatsView(character: character)
                    CharacterDetailTagsView(character: character)
                    CharacterDetailSectionsView(character: character)
                }
                .padding(.horizontal, DSDimens.spacing_5)
            }
        } else if viewModel.state == .error {
            ErrorView {
                await fetchCharacter()
            }
        } else {
            LoadingView()
        }
    }
    
    @ViewBuilder
    private func builBackButton() -> some View {
        Button(action: coordinator.pop) {
            HStack(spacing: DSDimens.spacing_2) {
                Image(systemName: "chevron.left")
                    .font(.bodyMedium)
                
                Text(AppStrings.charactersTitle)
                    .font(.bodyMedium)
            }
            .foregroundStyle(.ink(.film))
        }
    }
    
    @ViewBuilder
    private func buildCharacterFavoriteView() -> some View {
        if let character = viewModel.character {
            CharacterFavoriteView(
                isFavorite: character.isFavorite,
                action: viewModel.toggleFavorite
            )
        }
    }

    private func fetchCharacter() async {
        await viewModel.fetchCharacter()
    }
}

#if DEBUG
#Preview {
    CharacterDetailView(
        viewModel: CharacterDetailViewModel(
            characterId: 117,
            fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseMock()
        ),
        coordinator: AppCoordinator()
    )
}
#endif
