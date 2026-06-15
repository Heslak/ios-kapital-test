//
//  FetchUsersUseCaseMock.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

#if DEBUG
struct FetchUsersUseCaseMock: FetchUsersUseCaseProtocol {
    func fetchUsers(page: Int) -> AsyncThrowingStream<CharactersList, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(CharacterInfo.makeMockCharactersList())
            continuation.finish()
        }
    }
    
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws { }
}
#endif
