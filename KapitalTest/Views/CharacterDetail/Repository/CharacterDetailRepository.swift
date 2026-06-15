//
//  CharacterDetailRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService
import NetworkService

protocol CharacterDetailRepositoryProtocol {
    func fetchLocalCharacter(id: Int) throws -> CharacterInfo?
    func syncRemoteCharacter(id: Int) async throws
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws
}

final class CharacterDetailRepository: CharacterDetailRepositoryProtocol {
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    
    init(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface
    ) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    func fetchLocalCharacter(id: Int) throws -> CharacterInfo? {
        try localStorageService.getCharacter(
            CharacterInfo.self,
            id: id
        )
    }
    
    func syncRemoteCharacter(id: Int) async throws {
        let endpoint = Endpoint.fetchDetail(id: String(id))
        let response: CharacterDetail = try await networkService.execute(endpoint)
        try localStorageService.saveCharacter(response.data)
    }
    
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
