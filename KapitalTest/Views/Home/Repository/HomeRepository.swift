//
//  HomeRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import NetworkService
import LocalStorageService

protocol HomeRepositoryProtocol {
    /// Reads one page from local storage.
    /// - Parameter page: Page number to fetch.
    func fetchLocalList(page: Int) throws -> CharactersList?
    
    /// Fetches one page from the remote API and stores it locally.
    /// - Parameter page: Page number to synchronize.
    func syncRemoteList(page: Int) async throws
    
    /// Updates the favorite flag for a stored character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws
}

// MARK: - Home Repository

final class HomeRepository: HomeRepositoryProtocol {
      
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    
    /// Creates the repository with its remote and local dependencies.
    /// - Parameters:
    ///   - networkService: Service used to fetch remote pages.
    ///   - localStorageService: Service used to read and persist local pages.
    init(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface
    ) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    // MARK: - Local Reads
    
    /// Reads one locally stored characters page.
    /// - Parameter page: Page number to fetch.
    func fetchLocalList(page: Int) throws -> CharactersList? {
        try localStorageService.getCharactersList(
            CharactersList.self,
            page: page
        )
    }
    
    // MARK: - Remote Sync
    
    /// Downloads one page and saves it as the latest local snapshot.
    /// - Parameter page: Page number to synchronize.
    func syncRemoteList(page: Int) async throws {
        let endpoint = Endpoint.fetchList(page: page)
        let charactersList: CharactersList = try await networkService.execute(endpoint)
        try localStorageService.saveCharactersList(
            charactersList,
            page: page
        )
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
