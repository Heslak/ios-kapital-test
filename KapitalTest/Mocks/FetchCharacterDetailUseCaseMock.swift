//
//  FetchCharacterDetailUseCaseMock.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

#if DEBUG
struct FetchCharacterDetailUseCaseMock: FetchCharacterDetailUseCaseProtocol {
    func fetchCharacter(id: Int) -> AsyncThrowingStream<CharacterInfo, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(
                CharacterInfo.getMockCharacter()
            )
            continuation.finish()
        }
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws { }
}
#endif
