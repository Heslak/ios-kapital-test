//
//  FetchCharacterDetailUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

protocol FetchCharacterDetailUseCaseProtocol {
    /// Returns the local character first, then yields the synced local result after the remote update.
    /// - Parameter id: Character identifier.
    func fetchCharacter(id: Int) -> AsyncThrowingStream<CharacterInfo, Error>
    
    /// Updates the favorite flag for a character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(id: Int, isFavorite: Bool) throws
}

// MARK: - Fetch Character Detail Use Case

final class FetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol {
    private typealias CharacterContinuation = AsyncThrowingStream<CharacterInfo, Error>.Continuation
    
    private let repository: CharacterDetailRepositoryProtocol
    
    /// Creates the use case with the repository that owns detail synchronization.
    /// - Parameter repository: Repository used for local reads, remote sync and favorites.
    init(repository: CharacterDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public API
    
    /// Streams the offline-first character detail for the requested id.
    /// - Parameter id: Character identifier.
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
    
    /// Persists the favorite state for one character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        try repository.setFavorite(
            id: id,
            isFavorite: isFavorite
        )
    }
    
    // MARK: - Offline First Flow
    
    /// Loads local data, yields it when present, then starts remote synchronization.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - continuation: Stream continuation used to yield states.
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
    
    /// Reads the current local character snapshot.
    /// - Parameter id: Character identifier.
    private func fetchLocalCharacter(id: Int) throws -> CharacterInfo? {
        try repository.fetchLocalCharacter(id: id)
    }
    
    /// Emits a local character only when it exists.
    /// - Parameters:
    ///   - character: Optional local character.
    ///   - continuation: Stream continuation used to yield the character.
    private func yield(
        _ character: CharacterInfo?,
        continuation: CharacterContinuation
    ) {
        guard let character else { return }
        continuation.yield(character)
    }
    
    /// Syncs remote data and finishes the stream according to local and remote availability.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - localCharacter: Local snapshot already yielded, if any.
    ///   - continuation: Stream continuation used to yield or finish.
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
    
    /// Fetches the remote character, stores it locally and yields the updated local snapshot.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - continuation: Stream continuation used to yield updated data.
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
    
    // MARK: - Stream Completion
    
    /// Completes the stream after a successful sync attempt.
    /// - Parameters:
    ///   - localCharacter: Previously available local data, if any.
    ///   - didYieldUpdatedCharacter: Whether remote sync produced an updated local character.
    ///   - continuation: Stream continuation to finish.
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
    
    /// Completes the stream after a failed sync attempt.
    /// - Parameters:
    ///   - error: Error produced during sync.
    ///   - localCharacter: Previously available local data, if any.
    ///   - continuation: Stream continuation to finish.
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
