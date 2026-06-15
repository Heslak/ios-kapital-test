//
//  HomeViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation
import Combine

enum ViewState: Equatable {
    case shouldLoad
    case loading
    case loaded
    case error
}

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published private(set) var state: ViewState = .shouldLoad
    @Published var charactersList: CharactersList?
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private var currentPage = 1
        
    init(fetchUsersUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }
    
    func fetchUsers() async {
        guard state != .loading else { return }
        
        currentPage = 1
        
        await loadPage(
            currentPage,
            onReceive: replaceCharactersList,
            failureState: .error
        )
    }
    
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
    
    @discardableResult
    private func loadPage(
        _ page: Int,
        onReceive: (CharactersList) -> Void,
        failureState: ViewState
    ) async -> Bool {
        state = .loading
        
        do {
            for try await charactersList in fetchUsersUseCase.fetchUsers(page: page) {
                onReceive(charactersList)
            }
            
            state = .loaded
            return true
        } catch {
            state = failureState
            return false
        }
    }
    
    private func shouldLoadNextPage(currentCharacter: CharacterInfo) -> Bool {
        state == .loaded &&
        currentCharacter.id == charactersList?.data.last?.id &&
        charactersList?.info.nextPage.isEmpty == false
    }
    
    private func isLastCharacter(_ character: CharacterInfo) -> Bool {
        character.id == charactersList?.data.last?.id
    }
    
    private func replaceCharactersList(_ charactersList: CharactersList) {
        self.charactersList = charactersList
    }
    
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
}
