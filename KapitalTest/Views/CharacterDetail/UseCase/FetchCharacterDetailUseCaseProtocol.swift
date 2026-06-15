//
//  FetchCharacterDetailUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

protocol FetchCharacterDetailUseCaseProtocol {
    func fetchCharacter(id: Int) -> AsyncThrowingStream<CharacterInfo, Error>
    func setFavorite(id: Int, isFavorite: Bool) throws
}

final class FetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol {
    private typealias CharacterContinuation = AsyncThrowingStream<CharacterInfo, Error>.Continuation
    
    private let repository: CharacterDetailRepositoryProtocol
    
    init(repository: CharacterDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchCharacter(id: Int) -> AsyncThrowingStream<CharacterInfo, Error> {
        AsyncThrowingStream { continuation in
            Task {
                await self.executeFetch(
                    id: id,
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
        id: Int,
        continuation: CharacterContinuation
    ) async {
        do {
            let localCharacter = try fetchLocalCharacter(id: id)
            yield(localCharacter, continuation: continuation)
            await syncAndFinish(
                id: id,
                localCharacter: localCharacter,
                continuation: continuation
            )
        } catch {
            continuation.finish(throwing: error)
        }
    }
    
    private func fetchLocalCharacter(id: Int) throws -> CharacterInfo? {
        try repository.fetchLocalCharacter(id: id)
    }
    
    private func yield(
        _ character: CharacterInfo?,
        continuation: CharacterContinuation
    ) {
        guard let character else { return }
        continuation.yield(character)
    }
    
    private func syncAndFinish(
        id: Int,
        localCharacter: CharacterInfo?,
        continuation: CharacterContinuation
    ) async {
        do {
            let didYieldUpdatedCharacter = try await syncAndYieldUpdatedCharacter(
                id: id,
                continuation: continuation
            )
            finish(
                localCharacter: localCharacter,
                didYieldUpdatedCharacter: didYieldUpdatedCharacter,
                continuation: continuation
            )
        } catch {
            finish(
                error: error,
                localCharacter: localCharacter,
                continuation: continuation
            )
        }
    }
    
    private func syncAndYieldUpdatedCharacter(
        id: Int,
        continuation: CharacterContinuation
    ) async throws -> Bool {
        try await repository.syncRemoteCharacter(id: id)
        
        guard let updatedCharacter = try fetchLocalCharacter(id: id) else {
            return false
        }
        
        continuation.yield(updatedCharacter)
        return true
    }
    
    private func finish(
        localCharacter: CharacterInfo?,
        didYieldUpdatedCharacter: Bool,
        continuation: CharacterContinuation
    ) {
        if localCharacter != nil || didYieldUpdatedCharacter {
            continuation.finish()
        } else {
            continuation.finish(
                throwing: CharacterDetailUseCaseError.characterNotFound
            )
        }
    }
    
    private func finish(
        error: Error,
        localCharacter: CharacterInfo?,
        continuation: CharacterContinuation
    ) {
        if localCharacter != nil {
            continuation.finish()
        } else {
            continuation.finish(throwing: error)
        }
    }
}

enum CharacterDetailUseCaseError: Error {
    case characterNotFound
}
