//
//  HomeViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation
import Combine

// MARK: - Home View Model

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published private(set) var state: ViewState = .shouldLoad
    @Published var charactersList: CharactersList?
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private var currentPage = 1
    private var loadPageTask: Task<Void, Never>?
    
    /// Creates the view model with the use case that owns offline-first synchronization.
    /// - Parameter fetchUsersUseCase: Use case used to load pages and update favorites.
    init(fetchUsersUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }
    
    // MARK: - Loading
    
    /// Loads the first page and replaces the current list with the streamed result.
    func fetchUsers() async {
        guard state != .loading else { return }
        
        currentPage = 1
        
        await loadPage(
            currentPage,
            onReceive: replaceCharactersList,
            failureState: .error
        )
    }
    
    /// Loads the next page only when the current character is the last visible item.
    /// - Parameter currentCharacter: Character currently being rendered by the list.
    func loadNextPageIfNeeded(currentCharacter: CharacterInfo) async {
        guard shouldLoadNextPage(currentCharacter: currentCharacter) else {
            return
        }
        
        let nextPage = currentPage + 1
        let didLoadPage = await loadPage(
            nextPage,
            onReceive: appendCharactersList,
            failureState: .loaded
        )
        
        if didLoadPage {
            currentPage = nextPage
        }
    }
    
    /// Cancels any in-progress page loading operation.
    func cancelLoadNextPage() {
        loadPageTask?.cancel()
        loadPageTask = nil
    }
    
    // MARK: - Favorites
    
    /// Optimistically toggles a character favorite value and rolls back if persistence fails.
    /// - Parameter character: Character selected by the user.
    func toggleFavorite(for character: CharacterInfo) {
        let isFavorite = !character.isFavorite
        
        updateFavorite(
            id: character.id,
            isFavorite: isFavorite
        )
        
        do {
            try fetchUsersUseCase.setFavorite(
                id: character.id,
                isFavorite: isFavorite
            )
        } catch {
            updateFavorite(
                id: character.id,
                isFavorite: character.isFavorite
            )
        }
    }
    
    // MARK: - Page Loading
    
    /// Loads one page using a custom merge strategy.
    /// - Parameters:
    ///   - page: Page number to load.
    ///   - onReceive: Closure used to merge each streamed list into the current state.
    ///   - failureState: State applied when the load fails.
    @discardableResult
    private func loadPage(
        _ page: Int,
        onReceive: (CharactersList) -> Void,
        failureState: ViewState
    ) async -> Bool {
        state = .loading
        
        do {
            for try await charactersList in fetchUsersUseCase.fetchUsers(page: page) {
                // Check if task was cancelled before updating state
                if Task.isCancelled { return false }
                onReceive(charactersList)
            }
            
            // Only update loaded state if task wasn't cancelled
            if !Task.isCancelled {
                state = .loaded
                return true
            }
            return false
        } catch {
            // Only update error state if task wasn't cancelled
            if !Task.isCancelled {
                state = failureState
            }
            return false
        }
    }
    
    /// Checks whether the list should request another page.
    /// - Parameter currentCharacter: Character currently being rendered by the list.
    private func shouldLoadNextPage(currentCharacter: CharacterInfo) -> Bool {
        state == .loaded &&
        currentCharacter.id == charactersList?.data.last?.id &&
        charactersList?.info.nextPage.isEmpty == false
    }
    
    // MARK: - List Mutations
    
    /// Replaces the visible list with the latest streamed snapshot.
    /// - Parameter charactersList: New list to display.
    private func replaceCharactersList(_ charactersList: CharactersList) {
        self.charactersList = charactersList
    }
    
    /// Appends a new page while replacing any duplicate ids with the incoming version.
    /// - Parameter nextCharactersList: Page returned by the use case.
    private func appendCharactersList(_ nextCharactersList: CharactersList) {
        guard let charactersList else {
            self.charactersList = nextCharactersList
            return
        }
        
        let nextIds = Set(nextCharactersList.data.map(\.id))
        let currentCharacters = charactersList.data.filter { character in
            !nextIds.contains(character.id)
        }
        
        self.charactersList = CharactersList(
            info: nextCharactersList.info,
            data: currentCharacters + nextCharactersList.data
        )
    }
    
    /// Updates a single character favorite flag in the visible list.
    /// - Parameters:
    ///   - id: Character identifier.
    ///   - isFavorite: New favorite value to display.
    private func updateFavorite(
        id: Int,
        isFavorite: Bool
    ) {
        guard let charactersList else { return }
        
        let characters = charactersList.data.map { character in
            guard character.id == id else { return character }
            return character.settingFavorite(isFavorite)
        }
        
        self.charactersList = CharactersList(
            info: charactersList.info,
            data: characters
        )
    }
    
    deinit {
        loadPageTask?.cancel()
    }
}
