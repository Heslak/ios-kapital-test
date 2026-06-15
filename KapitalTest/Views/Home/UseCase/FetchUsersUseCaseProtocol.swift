//
//  FetchUsersUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

protocol FetchUsersUseCaseProtocol {
    func fetchUsers(page: Int) -> AsyncThrowingStream<CharactersList, Error>
    func setFavorite(id: Int, isFavorite: Bool) throws
}

final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private typealias UsersContinuation = AsyncThrowingStream<CharactersList, Error>.Continuation
    
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUsers(page: Int) -> AsyncThrowingStream<CharactersList, Error> {
        AsyncThrowingStream { continuation in
            Task {
                await self.executeFetch(
                    page: page,
                    continuation: continuation
                )
            }
        }
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
    
    private func executeFetch(
        page: Int,
        continuation: UsersContinuation
    ) async {
        do {
            let localList = try fetchLocalList(page: page)
            yield(localList, continuation: continuation)
            await syncAndFinish(
                page: page,
                localList: localList,
                continuation: continuation
            )
        } catch {
            continuation.finish(throwing: error)
        }
    }
    
    private func fetchLocalList(page: Int) throws -> CharactersList? {
        try repository.fetchLocalList(page: page)
    }
    
    private func yield(
        _ charactersList: CharactersList?,
        continuation: UsersContinuation
    ) {
        guard let charactersList else { return }
        
        continuation.yield(charactersList)
    }
    
    private func syncAndFinish(
        page: Int,
        localList: CharactersList?,
        continuation: UsersContinuation
    ) async {
        do {
            let didYieldUpdatedList = try await syncAndYieldUpdatedList(
                page: page,
                continuation: continuation
            )
            finish(
                localList: localList,
                didYieldUpdatedList: didYieldUpdatedList,
                continuation: continuation
            )
        } catch {
            finish(
                error: error,
                localList: localList,
                continuation: continuation
            )
        }
    }
    
    private func syncAndYieldUpdatedList(
        page: Int,
        continuation: UsersContinuation
    ) async throws -> Bool {
        try await repository.syncRemoteList(page: page)
        
        guard let updatedList = try fetchLocalList(page: page) else {
            return false
        }
        
        continuation.yield(updatedList)
        return true
    }
    
    private func finish(
        localList: CharactersList?,
        didYieldUpdatedList: Bool,
        continuation: UsersContinuation
    ) {
        if localList != nil || didYieldUpdatedList {
            continuation.finish()
        } else {
            continuation.finish(
                throwing: HomeUseCaseError.charactersListNotFound
            )
        }
    }
    
    private func finish(
        error: Error,
        localList: CharactersList?,
        continuation: UsersContinuation
    ) {
        if localList != nil {
            continuation.finish()
        } else {
            continuation.finish(throwing: error)
        }
    }
}

enum HomeUseCaseError: Error {
    case charactersListNotFound
}
