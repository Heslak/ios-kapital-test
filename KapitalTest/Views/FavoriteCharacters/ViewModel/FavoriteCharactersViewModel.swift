//
//  FavoriteCharactersViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Combine
import Foundation

// MARK: - Favorite Characters View Model

@MainActor
final class FavoriteCharactersViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .shouldLoad
    @Published private(set) var characters: [CharacterInfo] = []
    
    private let fetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseProtocol
    private var fetchTask: Task<Void, Never>?
    
    /// Creates the view model with the use case that reads and updates favorites.
    /// - Parameter fetchFavoriteCharactersUseCase: Use case used for local favorite operations.
    init(fetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseProtocol) {
        self.fetchFavoriteCharactersUseCase = fetchFavoriteCharactersUseCase
    }
    
    // MARK: - Loading
    
    /// Loads all favorite characters from local storage.
    func fetchFavoriteCharacters() {
        // Cancel any previous fetch task
        fetchTask?.cancel()
        
        state = .loading
        
        fetchTask = Task {
            do {
                characters = try fetchFavoriteCharactersUseCase.fetchFavoriteCharacters()
                
                if !Task.isCancelled {
                    state = .loaded
                }
            } catch {
                if !Task.isCancelled {
                    state = .error
                }
            }
        }
    }
    
    /// Cancels any in-progress fetch operation.
    func cancelFetch() {
        fetchTask?.cancel()
        fetchTask = nil
    }
    
    // MARK: - Favorites
    
    /// Optimistically toggles a favorite and refreshes the favorite list after persistence.
    /// - Parameter character: Favorite character selected by the user.
    func toggleFavorite(for character: CharacterInfo) {
        let previousCharacters = characters
        let isFavorite = !character.isFavorite
        updateFavorite(
            id: character.id,
            isFavorite: isFavorite
        )
        
        do {
            try fetchFavoriteCharactersUseCase.setFavorite(
                id: character.id,
                isFavorite: isFavorite
            )
            
            fetchFavoriteCharacters()
        } catch {
            characters = previousCharacters
        }
    }
    
    // MARK: - State Mutations
    
    /// Updates or removes a character from the visible favorites list.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value. `false` removes the character from favorites.
    private func updateFavorite(
        id: Int,
        isFavorite: Bool
    ) {
        characters = characters.compactMap { character in
            guard character.id == id else { return character }
            guard isFavorite else { return nil }
            return character.settingFavorite(isFavorite)
        }
    }
    
    deinit {
        fetchTask?.cancel()
    }
}
