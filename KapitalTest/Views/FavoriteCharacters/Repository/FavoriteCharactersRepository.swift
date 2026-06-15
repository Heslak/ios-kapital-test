//
//  FavoriteCharactersRepository.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import LocalStorageService

protocol FavoriteCharactersRepositoryProtocol {
    func fetchFavoriteCharacters() throws -> [CharacterInfo]
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws
}

final class FavoriteCharactersRepository: FavoriteCharactersRepositoryProtocol {
    private let localStorageService: LocalStorageServiceInterface
    
    init(localStorageService: LocalStorageServiceInterface) {
        self.localStorageService = localStorageService
    }
    
    func fetchFavoriteCharacters() throws -> [CharacterInfo] {
        try localStorageService.getFavoriteCharacters(CharacterInfo.self)
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
