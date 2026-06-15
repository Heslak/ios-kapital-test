//
//  LocalStorageService.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

public struct LocalStorageServiceFactory {
    public static func makeLocalStorageService() -> LocalStorageServiceInterface {
        return LocalStorageService()
    }
}

public protocol LocalStorageServiceInterface {
    func saveCharactersList<List: LocalStorableCharactersList>(
        _ list: List,
        page: Int
    ) throws

    func getCharactersList<List: LocalStorableCharactersList>(
        _ type: List.Type,
        page: Int
    ) throws -> List?

    func getCharacter<Character: LocalStorableCharacterInfo>(
        _ type: Character.Type,
        id: Int
    ) throws -> Character?

    func setCharacterFavorite(
        id: Int,
        isFavorite: Bool
    ) throws

    func deleteCharactersList(page: Int) throws
    func deleteAllCharactersLists() throws
}

public protocol LocalStorableCharactersList {
    
    associatedtype Info: LocalStorableListInfo
    associatedtype Character: LocalStorableCharacterInfo
    
    var info: Info { get }
    var data: [Character] { get }

    init(
        info: Info,
        data: [Character]
    )
}

public protocol LocalStorableListInfo {
    var count: Int { get }
    var totalPages: Int { get }
    var previousPage: String? { get }
    var nextPage: String { get }

    init(
        count: Int,
        totalPages: Int,
        previousPage: String?,
        nextPage: String
    )
}

public protocol LocalStorableCharacterInfo {
    var id: Int { get }
    var films: [String] { get }
    var shortFilms: [String] { get }
    var tvShows: [String] { get }
    var videoGames: [String] { get }
    var parkAttractions: [String] { get }
    var allies: [String] { get }
    var enemies: [String] { get }
    var name: String { get }
    var imageUrl: String? { get }
    var url: String { get }
    var isFavorite: Bool { get }

    init(
        id: Int,
        films: [String],
        shortFilms: [String],
        tvShows: [String],
        videoGames: [String],
        parkAttractions: [String],
        allies: [String],
        enemies: [String],
        name: String,
        imageUrl: String?,
        url: String,
        isFavorite: Bool
    )
}
