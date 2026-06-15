//
//  LocalStorageService.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

public struct LocalStorageServiceFactory {
    /// Creates the default Core Data-backed local storage implementation.
    public static func makeLocalStorageService() -> LocalStorageServiceInterface {
        return LocalStorageService()
    }
}

public protocol LocalStorageServiceInterface {
    // MARK: - Characters List
    
    /// Persists one paginated list and its characters.
    /// - Parameters:
    ///   - list: List model that exposes pagination metadata and character data.
    ///   - page: Page number used as the unique key for this list.
    func saveCharactersList<List: LocalStorableCharactersList>(
        _ list: List,
        page: Int
    ) throws

    /// Returns one stored paginated list, if it exists.
    /// - Parameters:
    ///   - type: Concrete list type to rebuild from Core Data.
    ///   - page: Page number used to find the stored list.
    func getCharactersList<List: LocalStorableCharactersList>(
        _ type: List.Type,
        page: Int
    ) throws -> List?

    // MARK: - Characters
    
    /// Returns a stored character by id, if it exists.
    /// - Parameters:
    ///   - type: Concrete character type to rebuild from Core Data.
    ///   - id: Remote character identifier.
    func getCharacter<Character: LocalStorableCharacterInfo>(
        _ type: Character.Type,
        id: Int
    ) throws -> Character?

    /// Returns all stored characters marked as favorites.
    /// - Parameter type: Concrete character type to rebuild from Core Data.
    func getFavoriteCharacters<Character: LocalStorableCharacterInfo>(
        _ type: Character.Type
    ) throws -> [Character]

    /// Persists or updates one character while preserving its favorite state when already stored.
    /// - Parameter character: Character model to save.
    func saveCharacter<Character: LocalStorableCharacterInfo>(
        _ character: Character
    ) throws

    /// Updates the favorite flag for an existing character.
    /// - Parameters:
    ///   - id: Remote character identifier.
    ///   - isFavorite: New favorite value to store.
    func setCharacterFavorite(
        id: Int,
        isFavorite: Bool
    ) throws

    // MARK: - Deletion
    
    /// Deletes the stored list for a single page.
    /// - Parameter page: Page number used to find the list.
    func deleteCharactersList(page: Int) throws
    
    /// Deletes all stored paginated lists.
    func deleteAllCharactersLists() throws
}

public protocol LocalStorableCharactersList {
    
    associatedtype Info: LocalStorableListInfo
    associatedtype Character: LocalStorableCharacterInfo
    
    var info: Info { get }
    var data: [Character] { get }

    /// Rebuilds a list from storage-safe pagination info and characters.
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

    /// Rebuilds pagination metadata from stored values.
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

    /// Rebuilds a character from stored values without requiring app-specific mapping files.
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
