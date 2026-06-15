//
//  CharacterDetailViewModel.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .shouldLoad
    @Published private(set) var character: CharacterInfo?
    
    private let characterId: Int
    private let fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol
    
    init(
        characterId: Int,
        fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol
    ) {
        self.characterId = characterId
        self.fetchCharacterDetailUseCase = fetchCharacterDetailUseCase
    }
    
    func fetchCharacter() async {
        guard state != .loading else { return }
        
        state = .loading
        
        do {
            for try await character in fetchCharacterDetailUseCase.fetchCharacter(id: characterId) {
                self.character = character
            }
            state = .loaded
        } catch {
            state = .error
        }
    }
    
    func toggleFavorite() {
        guard let character else { return }
        
        let isFavorite = !character.isFavorite
        updateFavorite(isFavorite)
        
        do {
            try fetchCharacterDetailUseCase.setFavorite(
                id: character.id,
                isFavorite: isFavorite
            )
        } catch {
            updateFavorite(character.isFavorite)
        }
    }
    
    private func updateFavorite(_ isFavorite: Bool) {
        character = character?.settingFavorite(isFavorite)
    }
}
