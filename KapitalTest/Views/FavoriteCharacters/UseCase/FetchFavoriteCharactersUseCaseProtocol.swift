//
//  FetchFavoriteCharactersUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

protocol FetchFavoriteCharactersUseCaseProtocol {
    /// Returns all characters currently marked as favorite in local storage.
    func fetchFavoriteCharacters() throws -> [CharacterInfo]
    
    /// Updates the favorite flag for a character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(id: Int, isFavorite: Bool) throws
}

// MARK: - Fetch Favorite Characters Use Case

final class FetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseProtocol {
    private let repository: FavoriteCharactersRepositoryProtocol
    
    /// Creates the use case with the repository that owns favorite reads and writes.
    /// - Parameter repository: Repository used for local favorite operations.
    init(repository: FavoriteCharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public API
    
    /// Reads the current favorite characters from local storage.
    func fetchFavoriteCharacters() throws -> [CharacterInfo] {
        try repository.fetchFavoriteCharacters()
    }
    
    /// Persists the favorite state for one character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        try repository.setFavorite(
            id: id,
            isFavorite: isFavorite
        )
    }
}
