//
//  HomeRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import NetworkService
import LocalStorageService

protocol HomeRepositoryProtocol {
    func fetchLocalList(page: Int) throws -> CharactersList?
    func syncRemoteList(page: Int) async throws
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws
}

final class HomeRepository: HomeRepositoryProtocol {
      
    private let networkService: NetworkServiceInterface
    private let localStorageService: LocalStorageServiceInterface
    
    init(
        networkService: NetworkServiceInterface,
        localStorageService: LocalStorageServiceInterface
    ) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    func fetchLocalList(page: Int) throws -> CharactersList? {
        try localStorageService.getCharactersList(
            CharactersList.self,
            page: page
        )
    }
    
    func syncRemoteList(page: Int) async throws {
        let endpoint = Endpoint.fetchList(page: page)
        let charactersList: CharactersList = try await networkService.execute(endpoint)
        try localStorageService.saveCharactersList(
            charactersList,
            page: page
        )
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
