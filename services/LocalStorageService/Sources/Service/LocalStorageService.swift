//
//  LocalStorageService.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 12/06/26.
//

import CoreData
import Foundation

final class LocalStorageService: LocalStorageServiceInterface {
    private let coreDataStack: LocalStorageCoreDataStack

    init(coreDataStack: LocalStorageCoreDataStack = LocalStorageCoreDataStack()) {
        self.coreDataStack = coreDataStack
    }

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
                try makeCharacterEntity(
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

    func deleteCharactersList(page: Int) throws {
        try coreDataStack.performAndWait { context in
            guard let entity = try fetchCharactersListEntity(page: page, context: context) else {
                return
            }
            context.delete(entity)
            try saveIfNeeded(context)
        }
    }

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

    private func makeCharacterEntity<Character: LocalStorableCharacterInfo>(
        from character: Character,
        isFavorite: Bool,
        orderIndex: Int,
        listEntity: CharactersListEntity,
        context: NSManagedObjectContext
    ) throws -> CharacterInfoEntity {
        let entity = try insertEntity(
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

    private func makeCharactersListEntity(
        context: NSManagedObjectContext
    ) throws -> CharactersListEntity {
        try insertEntity(
            CharactersListEntity.self,
            entityName: CharactersListEntity.entityName,
            context: context
        )
    }

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

    private func saveIfNeeded(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
