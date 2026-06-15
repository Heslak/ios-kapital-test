//
//  FetchFavoriteCharactersUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

protocol FetchFavoriteCharactersUseCaseProtocol {
    func fetchFavoriteCharacters() throws -> [CharacterInfo]
    func setFavorite(id: Int, isFavorite: Bool) throws
}

final class FetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseProtocol {
    private let repository: FavoriteCharactersRepositoryProtocol
    
    init(repository: FavoriteCharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchFavoriteCharacters() throws -> [CharacterInfo] {
        try repository.fetchFavoriteCharacters()
    }
    
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
