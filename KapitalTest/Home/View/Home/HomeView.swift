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
        let favoriteCharacters = favoriteCharacters(from: charactersList)
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: DSDimens.spacing_5) {
                HomeTitleView()
                
                if !favoriteCharacters.isEmpty {
                    FavoriteCharactersListView(characters: favoriteCharacters)
                        .transition(favoritesTransition)
                }
                
                Text("All Characters")
                    .font(.h2Bold)
                    .foregroundStyle(.ink(.primary))
                
                ForEach(charactersList.data, id: \.id) { character in
                    CharacterListCell(
                        character: character,
                        favoriteAction: toggleFavorite
                    )
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
    
    private var favoritesTransition: AnyTransition {
        .modifier(
            active: FavoriteSectionTransitionModifier(progress: 0.0),
            identity: FavoriteSectionTransitionModifier(progress: 1.0)
        )
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
    
    private func favoriteCharacters(
        from charactersList: CharactersList
    ) -> [CharacterInfo] {
        charactersList.data.filter(\.isFavorite)
    }
}

#if DEBUG
#Preview {
    HomeView(
        viewModel: HomeViewModel(fetchUsersUseCase: FetchUsersUseCaseMock()),
        coordinator: AppCoordinator()
    )
}

struct FetchUsersUseCaseMock: FetchUsersUseCaseProtocol {
    func fetchUsers(page: Int) -> AsyncThrowingStream<CharactersList, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(makeMockCharactersList())
            continuation.finish()
        }
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws { }
    
    func makeMockCharactersList() -> CharactersList {
        return CharactersList(
            info: ListInfo(
                count: 6,
                totalPages: 1,
                previousPage: nil,
                nextPage: ""
            ),
            data: [
                CharacterInfo(
                    id: 1,
                    films: ["Hercules"],
                    shortFilms: [],
                    tvShows: ["Hercules"],
                    videoGames: ["Kingdom Hearts"],
                    parkAttractions: [],
                    allies: [],
                    enemies: [],
                    name: "Achilles",
                    imageUrl: nil,
                    url: "",
                    isFavorite: true
                ),
                CharacterInfo(
                    id: 2,
                    films: ["Hercules"],
                    shortFilms: [],
                    tvShows: ["Hercules"],
                    videoGames: ["Kingdom Hearts", "Disney Magic Kingdoms"],
                    parkAttractions: ["Sorcerers of the Magic Kingdom"],
                    allies: [],
                    enemies: [],
                    name: "Hercules",
                    imageUrl: nil,
                    url: "",
                    isFavorite: true
                ),
                CharacterInfo(
                    id: 3,
                    films: ["Hercules"],
                    shortFilms: [],
                    tvShows: ["Hercules"],
                    videoGames: [],
                    parkAttractions: [],
                    allies: [],
                    enemies: [],
                    name: "Megara",
                    imageUrl: nil,
                    url: "",
                    isFavorite: true
                ),
                CharacterInfo(
                    id: 4,
                    films: ["Hercules"],
                    shortFilms: [],
                    tvShows: ["Hercules"],
                    videoGames: ["Kingdom Hearts"],
                    parkAttractions: [],
                    allies: [],
                    enemies: [],
                    name: "Hades",
                    imageUrl: nil,
                    url: "",
                    isFavorite: true
                ),
                CharacterInfo(
                    id: 5,
                    films: ["Hercules"],
                    shortFilms: [],
                    tvShows: ["Hercules"],
                    videoGames: [],
                    parkAttractions: [],
                    allies: [],
                    enemies: [],
                    name: "Philoctetes",
                    imageUrl: nil,
                    url: ""
                ),
                CharacterInfo(
                    id: 6,
                    films: ["Hercules"],
                    shortFilms: [],
                    tvShows: ["Hercules"],
                    videoGames: [],
                    parkAttractions: ["Hercules and Xena"],
                    allies: [],
                    enemies: [],
                    name: "Pegasus",
                    imageUrl: nil,
                    url: ""
                )
            ]
        )
    }
}
#endif
