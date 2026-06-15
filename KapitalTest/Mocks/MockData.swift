//
//  MockData.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation

#if DEBUG
extension CharacterInfo {
    static func makeMockCharactersList() -> CharactersList {
        return CharactersList(
            info: getMockListInfo(),
            data: getMockCharacterArray()
        )
    }
    
    static func getMockListInfo() -> ListInfo {
        ListInfo(
            count: 6,
            totalPages: 1,
            previousPage: nil,
            nextPage: ""
        )
    }
    
    static func getMockCharacterArray() -> [CharacterInfo] {
        [
            getMockCharacter(),
            getMockCharacter(),
            getMockCharacter(),
            getMockCharacter(),
            getMockCharacter(),
            getMockCharacter()
        ]
    }
    
    static func getMockCharacter() -> CharacterInfo {
        CharacterInfo(
            id: 117,
            films: ["Hercules"],
            shortFilms: [],
            tvShows: ["Hercules"],
            videoGames: [],
            parkAttractions: ["Disneyland"],
            allies: ["Hercules", "Philoctetes"],
            enemies: ["Hades"],
            name: "Pegasus",
            imageUrl: nil,
            url: "",
            isFavorite: false
        )
    }
}
#endif
