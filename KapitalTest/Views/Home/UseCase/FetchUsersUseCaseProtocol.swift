//
//  FetchUsersUseCaseProtocol.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

protocol FetchUsersUseCaseProtocol {
    /// Returns local characters first, then yields the synced local result after the remote update.
    /// - Parameter page: Page number to load.
    func fetchUsers(page: Int) -> AsyncThrowingStream<CharactersList, Error>
    
    /// Updates the favorite flag for a character.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value.
    func setFavorite(id: Int, isFavorite: Bool) throws
}

// MARK: - Fetch Users Use Case

final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private typealias UsersContinuation = AsyncThrowingStream<CharactersList, Error>.Continuation
    
    private let repository: HomeRepositoryProtocol
    
    /// Creates the use case with the repository that owns data synchronization.
    /// - Parameter repository: Repository used for local reads, remote sync and favorites.
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public API
    
    /// Streams the offline-first list for the requested page.
    /// - Parameter page: Page number to fetch.
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
    ///   - page: Page number to fetch.
    ///   - continuation: Stream continuation used to yield states.
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
    
    /// Reads the current local page snapshot.
    /// - Parameter page: Page number to fetch from local storage.
    private func fetchLocalList(page: Int) throws -> CharactersList? {
        try repository.fetchLocalList(page: page)
    }
    
    /// Emits a local list only when it exists.
    /// - Parameters:
    ///   - charactersList: Optional local list.
    ///   - continuation: Stream continuation used to yield the list.
    private func yield(
        _ charactersList: CharactersList?,
        continuation: UsersContinuation
    ) {
        guard let charactersList else { return }
        
        continuation.yield(charactersList)
    }
    
    /// Syncs remote data and finishes the stream according to local and remote availability.
    /// - Parameters:
    ///   - page: Page number to synchronize.
    ///   - localList: Local snapshot already yielded, if any.
    ///   - continuation: Stream continuation used to yield or finish.
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
    
    /// Fetches the remote page, stores it locally and yields the updated local snapshot.
    /// - Parameters:
    ///   - page: Page number to synchronize.
    ///   - continuation: Stream continuation used to yield updated data.
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
    
    // MARK: - Stream Completion
    
    /// Completes the stream after a successful sync attempt.
    /// - Parameters:
    ///   - localList: Previously available local data, if any.
    ///   - didYieldUpdatedList: Whether remote sync produced an updated local list.
    ///   - continuation: Stream continuation to finish.
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
    
    /// Completes the stream after a failed sync attempt.
    /// - Parameters:
    ///   - error: Error produced during sync.
    ///   - localList: Previously available local data, if any.
    ///   - continuation: Stream continuation to finish.
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
