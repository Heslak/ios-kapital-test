//
//  CharacterDetailViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation
import Combine

// MARK: - Character Detail View Model

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .shouldLoad
    @Published private(set) var character: CharacterInfo?
    
    private let characterId: Int
    private let fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol
    
    /// Creates the view model for a specific character detail screen.
    /// - Parameters:
    ///   - characterId: Character identifier requested by the route.
    ///   - fetchCharacterDetailUseCase: Use case used to load detail and update favorites.
    init(
        characterId: Int,
        fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol
    ) {
        self.characterId = characterId
        self.fetchCharacterDetailUseCase = fetchCharacterDetailUseCase
    }
    
    // MARK: - Loading
    
    /// Loads the character detail using the offline-first stream from the use case.
    func fetchCharacter() async {
        guard state != .loading else { return }
        
        state = .loading
        
        do {
            for try await character in fetchCharacterDetailUseCase.fetchCharacter(id: characterId) {
                self.character = character
            }
            state = .loaded
        } catch {
            state = .error
        }
    }
    
    // MARK: - Favorites
    
    /// Optimistically toggles the current character favorite value and rolls back if persistence fails.
    func toggleFavorite() {
        guard let character else { return }
        
        let isFavorite = !character.isFavorite
        updateFavorite(isFavorite)
        
        do {
            try fetchCharacterDetailUseCase.setFavorite(
                id: character.id,
                isFavorite: isFavorite
            )
        } catch {
            updateFavorite(character.isFavorite)
        }
    }
    
    // MARK: - State Mutations
    
    /// Updates the visible favorite value without mutating the original character instance.
    /// - Parameter isFavorite: New favorite value to display.
    private func updateFavorite(_ isFavorite: Bool) {
        character = character?.settingFavorite(isFavorite)
    }
}
