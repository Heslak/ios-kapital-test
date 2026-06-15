//
//  LocalStorageService.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 12/06/26.
//

import CoreData
import Foundation

// MARK: - Local Storage Service

final class LocalStorageService: LocalStorageServiceInterface {
    private let coreDataStack: LocalStorageCoreDataStack

    /// Creates the service with a configurable Core Data stack.
    /// - Parameter coreDataStack: Stack used to execute Core Data operations.
    init(coreDataStack: LocalStorageCoreDataStack = LocalStorageCoreDataStack()) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Characters List
    
    /// Saves a paginated list, replacing the page snapshot and preserving stored favorite flags.
    /// - Parameters:
    ///   - list: Page payload to persist.
    ///   - page: Page number used as the list unique key.
    func saveCharactersList<List: LocalStorableCharactersList>(
        _ list: List,
        page: Int
    ) throws {
        try coreDataStack.performAndWait { context in
            let favoriteIds = try fetchFavoriteIds(context: context)

            if let existingList = try fetchCharactersListEntity(page: page, context: context) {
                context.delete(existingList)
                try saveIfNeeded(context)
            }

            let listEntity = try makeCharactersListEntity(context: context)
            listEntity.page = Int64(page)
            listEntity.count = Int64(list.info.count)
            listEntity.totalPages = Int64(list.info.totalPages)
            listEntity.previousPage = list.info.previousPage
            listEntity.nextPage = list.info.nextPage
            listEntity.updatedAt = Date()

            let characters = try list.data.enumerated().map { index, character in
                try upsertCharacterEntity(
                    from: character,
                    isFavorite: favoriteIds.contains(character.id) || character.isFavorite,
                    orderIndex: index,
                    listEntity: listEntity,
                    context: context
                )
            }
            listEntity.characters = Set(characters)

            try saveIfNeeded(context)
        }
    }

    /// Reads a paginated list and rebuilds it using the caller's concrete model type.
    /// - Parameters:
    ///   - type: Concrete list type expected by the app layer.
    ///   - page: Page number to fetch.
    func getCharactersList<List: LocalStorableCharactersList>(
        _ type: List.Type,
        page: Int
    ) throws -> List? {
        try coreDataStack.performAndWait { context in
            guard let listEntity = try fetchCharactersListEntity(page: page, context: context) else {
                return nil
            }

            let info = List.Info(
                count: Int(listEntity.count),
                totalPages: Int(listEntity.totalPages),
                previousPage: listEntity.previousPage,
                nextPage: listEntity.nextPage
            )
            
            let characters = listEntity.characters
                .sorted { $0.orderIndex < $1.orderIndex }
                .map { makeCharacter(from: $0, type: List.Character.self) }

            return List(
                info: info,
                data: characters
            )
        }
    }

    // MARK: - Characters
    
    /// Saves or updates one character while keeping its existing favorite state when present.
    /// - Parameter character: Character payload to persist.
    func saveCharacter<Character: LocalStorableCharacterInfo>(
        _ character: Character
    ) throws {
        try coreDataStack.performAndWait { context in
            let entity = try fetchCharacterEntity(
                id: character.id,
                context: context
            )
            let isFavorite = entity?.isFavorite ?? character.isFavorite
            
            _ = try upsertCharacterEntity(
                from: character,
                isFavorite: isFavorite,
                orderIndex: Int(entity?.orderIndex ?? 0),
                listEntity: entity?.list,
                context: context
            )
            
            try saveIfNeeded(context)
        }
    }
    
    /// Reads one stored character and rebuilds it using the caller's concrete model type.
    /// - Parameters:
    ///   - type: Concrete character type expected by the app layer.
    ///   - id: Remote character identifier.
    func getCharacter<Character: LocalStorableCharacterInfo>(
        _ type: Character.Type,
        id: Int
    ) throws -> Character? {
        try coreDataStack.performAndWait { context in
            guard let entity = try fetchCharacterEntity(id: id, context: context) else {
                return nil
            }
            return makeCharacter(from: entity, type: type)
        }
    }

    /// Reads favorite characters ordered by their list position and then by name.
    /// - Parameter type: Concrete character type expected by the app layer.
    func getFavoriteCharacters<Character: LocalStorableCharacterInfo>(
        _ type: Character.Type
    ) throws -> [Character] {
        try coreDataStack.performAndWait { context in
            let request = NSFetchRequest<CharacterInfoEntity>(
                entityName: CharacterInfoEntity.entityName
            )
            request.predicate = NSPredicate(format: "isFavorite == YES")
            request.sortDescriptors = [
                NSSortDescriptor(key: "orderIndex", ascending: true),
                NSSortDescriptor(key: "name", ascending: true)
            ]
            
            return try context.fetch(request).map {
                makeCharacter(from: $0, type: type)
            }
        }
    }

    /// Updates the favorite flag for a previously stored character.
    /// - Parameters:
    ///   - id: Remote character identifier.
    ///   - isFavorite: New favorite value to persist.
    func setCharacterFavorite(
        id: Int,
        isFavorite: Bool
    ) throws {
        try coreDataStack.performAndWait { context in
            guard let entity = try fetchCharacterEntity(id: id, context: context) else {
                throw LocalStorageError.characterNotFound(id: id)
            }
            
            entity.isFavorite = isFavorite
            entity.updatedAt = Date()
            try saveIfNeeded(context)
        }
    }
    
    // MARK: - Deletion
    
    /// Deletes a single page snapshot.
    /// - Parameter page: Page number to remove.
    func deleteCharactersList(page: Int) throws {
        try coreDataStack.performAndWait { context in
            guard let entity = try fetchCharactersListEntity(page: page, context: context) else {
                return
            }
            context.delete(entity)
            try saveIfNeeded(context)
        }
    }

    /// Deletes every stored page snapshot.
    func deleteAllCharactersLists() throws {
        try coreDataStack.performAndWait { context in
            let request = NSFetchRequest<CharactersListEntity>(
                entityName: CharactersListEntity.entityName
            )
            let lists = try context.fetch(request)
            lists.forEach(context.delete)
            try saveIfNeeded(context)
        }
    }

    // MARK: - Entity Mapping
    
    /// Inserts or updates a character entity with the provided storage metadata.
    /// - Parameters:
    ///   - character: Domain-facing character payload.
    ///   - isFavorite: Favorite state to store.
    ///   - orderIndex: Position inside the paginated list.
    ///   - listEntity: Parent list entity, if this character belongs to a list page.
    ///   - context: Context used for the write operation.
    private func upsertCharacterEntity<Character: LocalStorableCharacterInfo>(
        from character: Character,
        isFavorite: Bool,
        orderIndex: Int,
        listEntity: CharactersListEntity?,
        context: NSManagedObjectContext
    ) throws -> CharacterInfoEntity {
        let entity = try fetchCharacterEntity(
            id: character.id,
            context: context
        ) ?? insertEntity(
            CharacterInfoEntity.self,
            entityName: CharacterInfoEntity.entityName,
            context: context
        )
        entity.id = Int64(character.id)
        entity.orderIndex = Int64(orderIndex)
        entity.films = character.films
        entity.shortFilms = character.shortFilms
        entity.tvShows = character.tvShows
        entity.videoGames = character.videoGames
        entity.parkAttractions = character.parkAttractions
        entity.allies = character.allies
        entity.enemies = character.enemies
        entity.name = character.name
        entity.imageUrl = character.imageUrl
        entity.url = character.url
        entity.isFavorite = isFavorite
        entity.updatedAt = Date()
        entity.list = listEntity
        return entity
    }

    /// Inserts a new list entity in the provided context.
    /// - Parameter context: Context used for the insert operation.
    private func makeCharactersListEntity(
        context: NSManagedObjectContext
    ) throws -> CharactersListEntity {
        try insertEntity(
            CharactersListEntity.self,
            entityName: CharactersListEntity.entityName,
            context: context
        )
    }

    /// Inserts and type-checks a Core Data entity.
    /// - Parameters:
    ///   - type: Expected managed object subclass.
    ///   - entityName: Core Data entity name.
    ///   - context: Context used for the insert operation.
    private func insertEntity<Entity: NSManagedObject>(
        _ type: Entity.Type,
        entityName: String,
        context: NSManagedObjectContext
    ) throws -> Entity {
        guard let entity = NSEntityDescription.insertNewObject(
            forEntityName: entityName,
            into: context
        ) as? Entity else {
            throw LocalStorageError.invalidEntity(entityName)
        }
        return entity
    }

    /// Converts a stored managed object into the caller's concrete character type.
    /// - Parameters:
    ///   - entity: Stored character entity.
    ///   - type: Concrete character type to rebuild.
    private func makeCharacter<Character: LocalStorableCharacterInfo>(
        from entity: CharacterInfoEntity,
        type: Character.Type
    ) -> Character {
        Character(
            id: Int(entity.id),
            films: entity.films,
            shortFilms: entity.shortFilms,
            tvShows: entity.tvShows,
            videoGames: entity.videoGames,
            parkAttractions: entity.parkAttractions,
            allies: entity.allies,
            enemies: entity.enemies,
            name: entity.name,
            imageUrl: entity.imageUrl,
            url: entity.url,
            isFavorite: entity.isFavorite
        )
    }

    // MARK: - Fetch Helpers
    
    /// Fetches all favorite character ids to preserve favorites during page replacement.
    /// - Parameter context: Context used for the fetch operation.
    private func fetchFavoriteIds(
        context: NSManagedObjectContext
    ) throws -> Set<Int> {
        let request = NSFetchRequest<CharacterInfoEntity>(
            entityName: CharacterInfoEntity.entityName
        )
        request.predicate = NSPredicate(format: "isFavorite == YES")
        return Set(
            try context.fetch(request).map { Int($0.id) }
        )
    }

    /// Fetches the stored list entity for a page.
    /// - Parameters:
    ///   - page: Page number used as unique key.
    ///   - context: Context used for the fetch operation.
    private func fetchCharactersListEntity(
        page: Int,
        context: NSManagedObjectContext
    ) throws -> CharactersListEntity? {
        let request = NSFetchRequest<CharactersListEntity>(
            entityName: CharactersListEntity.entityName
        )
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "page == %d", page)
        return try context.fetch(request).first
    }

    /// Fetches a stored character entity by remote id.
    /// - Parameters:
    ///   - id: Remote character identifier.
    ///   - context: Context used for the fetch operation.
    private func fetchCharacterEntity(
        id: Int,
        context: NSManagedObjectContext
    ) throws -> CharacterInfoEntity? {
        let request = NSFetchRequest<CharacterInfoEntity>(
            entityName: CharacterInfoEntity.entityName
        )
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id)
        return try context.fetch(request).first
    }

    // MARK: - Persistence
    
    /// Saves the context only when it contains pending changes.
    /// - Parameter context: Context that may need to be saved.
    private func saveIfNeeded(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
