//
//  FavoriteCharactersRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService

protocol FavoriteCharactersRepositoryProtocol {
    /// Reads all favorite characters from local storage.
    func fetchFavoriteCharacters() throws -> [CharacterInfo]
    
    /// Updates the favorite flag for a stored character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws
}

// MARK: - Favorite Characters Repository

final class FavoriteCharactersRepository: FavoriteCharactersRepositoryProtocol {
    private let localStorageService: LocalStorageServiceInterface
    
    /// Creates the repository with the local storage dependency.
    /// - Parameter localStorageService: Service used to read and update favorites.
    init(localStorageService: LocalStorageServiceInterface) {
        self.localStorageService = localStorageService
    }
    
    // MARK: - Local Reads
    
    /// Reads all locally stored favorite characters.
    func fetchFavoriteCharacters() throws -> [CharacterInfo] {
        try localStorageService.getFavoriteCharacters(CharacterInfo.self)
    }
    
    // MARK: - Favorites
    
    /// Persists the favorite state for one character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        try localStorageService.setCharacterFavorite(
            id: id,
            isFavorite: isFavorite
        )
    }
}
