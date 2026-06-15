//
//  FetchFavoriteCharactersUseCaseMock.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

#if DEBUG
struct FetchFavoriteCharactersUseCaseMock: FetchFavoriteCharactersUseCaseProtocol {
    func fetchFavoriteCharacters() throws -> [CharacterInfo] {
        [.getMockCharacter().settingFavorite(true)]
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws { }
}
#endif
