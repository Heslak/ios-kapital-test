//
//  CharacterInfoEntity.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import CoreData
import Foundation

final class CharacterInfoEntity: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var orderIndex: Int64
    @NSManaged var films: [String]
    @NSManaged var shortFilms: [String]
    @NSManaged var tvShows: [String]
    @NSManaged var videoGames: [String]
    @NSManaged var parkAttractions: [String]
    @NSManaged var allies: [String]
    @NSManaged var enemies: [String]
    @NSManaged var name: String
    @NSManaged var imageUrl: String?
    @NSManaged var url: String
    @NSManaged var isFavorite: Bool
    @NSManaged var updatedAt: Date
    @NSManaged var list: CharactersListEntity?
}

extension CharacterInfoEntity {
    static let entityName = "CharacterInfoEntity"
}
