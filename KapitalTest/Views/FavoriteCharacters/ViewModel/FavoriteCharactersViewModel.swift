//
//  FavoriteCharactersViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Combine
import Foundation

@MainActor
final class FavoriteCharactersViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .shouldLoad
    @Published private(set) var characters: [CharacterInfo] = []
    
    private let fetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseProtocol
    
    init(fetchFavoriteCharactersUseCase: FetchFavoriteCharactersUseCaseProtocol) {
        self.fetchFavoriteCharactersUseCase = fetchFavoriteCharactersUseCase
    }
    
    func fetchFavoriteCharacters() {
        state = .loading
        
        do {
            characters = try fetchFavoriteCharactersUseCase.fetchFavoriteCharacters()
            state = .loaded
        } catch {
            state = .error
        }
    }
    
    func toggleFavorite(for character: CharacterInfo) {
        let previousCharacters = characters
        let isFavorite = !character.isFavorite
        updateFavorite(
            id: character.id,
            isFavorite: isFavorite
        )
        
        do {
            try fetchFavoriteCharactersUseCase.setFavorite(
                id: character.id,
                isFavorite: isFavorite
            )
            
            fetchFavoriteCharacters()
        } catch {
            characters = previousCharacters
        }
    }
    
    private func updateFavorite(
        id: Int,
        isFavorite: Bool
    ) {
        characters = characters.compactMap { character in
            guard character.id == id else { return character }
            guard isFavorite else { return nil }
            return character.settingFavorite(isFavorite)
        }
    }
}
