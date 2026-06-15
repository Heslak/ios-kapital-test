//
//  CharactersListEntity.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import CoreData
import Foundation

// MARK: - Characters List Entity

final class CharactersListEntity: NSManagedObject {
    @NSManaged var page: Int64
    @NSManaged var count: Int64
    @NSManaged var totalPages: Int64
    @NSManaged var previousPage: String?
    @NSManaged var nextPage: String
    @NSManaged var updatedAt: Date
    @NSManaged var characters: Set<CharacterInfoEntity>
}

extension CharactersListEntity {
    /// Core Data entity name used by programmatic fetch and insert requests.
    static let entityName = "CharactersListEntity"
}
