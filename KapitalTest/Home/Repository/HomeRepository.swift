//
//  HomeRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import NetworkService

protocol HomeRepositoryProtocol {
    func fetchList(page: Int) async throws -> CharactersList
}

final class HomeRepository: HomeRepositoryProtocol {
      
    private let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    func fetchList(page: Int) async throws -> CharactersList {
        let endpoint = Endpoint.fetchList(page: page)
        let charectersList: CharactersList = try await networkService.execute(endpoint)
        return charectersList
    }
}
