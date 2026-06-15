//
//  CharacterDetailRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService
import NetworkService

protocol CharacterDetailRepositoryProtocol {
    /// Reads one character from local storage.
    /// - Parameter id: Character identifier.
    func fetchLocalCharacter(id: Int) throws -> CharacterInfo?
    
    /// Fetches one character from the remote API and stores it locally.
    /// - Parameter id: Character identifier.
    func syncRemoteCharacter(id: Int) async throws
    
    /// Updates the favorite flag for a stored character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws
}

// MARK: - Character Detail Repository

final class CharacterDetailRepository: CharacterDetailRepositoryProtocol {
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    
    /// Creates the repository with its remote and local dependencies.
    /// - Parameters:
    ///   - networkService: Service used to fetch remote detail.
    ///   - localStorageService: Service used to read and persist local characters.
    init(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface
    ) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    // MARK: - Local Reads
    
    /// Reads one locally stored character.
    /// - Parameter id: Character identifier.
    func fetchLocalCharacter(id: Int) throws -> CharacterInfo? {
        try localStorageService.getCharacter(
            CharacterInfo.self,
            id: id
        )
    }
    
    // MARK: - Remote Sync
    
    /// Downloads one character detail and saves it as the latest local snapshot.
    /// - Parameter id: Character identifier.
    func syncRemoteCharacter(id: Int) async throws {
        let endpoint = Endpoint.fetchDetail(id: String(id))
        let response: CharacterDetail = try await networkService.execute(endpoint)
        try localStorageService.saveCharacter(response.data)
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
