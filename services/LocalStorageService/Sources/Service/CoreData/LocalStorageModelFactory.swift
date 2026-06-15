//
//  LocalStorageModelFactory.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import CoreData
import Foundation

// MARK: - Programmatic Core Data Model

enum LocalStorageModelFactory {
    static let modelName = "LocalStorageModel"

    /// Creates the in-memory model description used by the persistent container.
    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        let charactersListEntity = makeCharactersListEntity()
        let characterInfoEntity = makeCharacterInfoEntity()
        configureRelationships(
            charactersListEntity: charactersListEntity,
            characterInfoEntity: characterInfoEntity
        )
        model.entities = [charactersListEntity, characterInfoEntity]
        return model
    }

    // MARK: - Entities
    
    /// Builds the entity that stores one paginated list snapshot.
    private static func makeCharactersListEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = CharactersListEntity.entityName
        entity.managedObjectClassName = NSStringFromClass(CharactersListEntity.self)
        entity.properties = [
            makeIntegerAttribute(named: "page"),
            makeIntegerAttribute(named: "count"),
            makeIntegerAttribute(named: "totalPages"),
            makeStringAttribute(named: "previousPage", isOptional: true),
            makeStringAttribute(named: "nextPage"),
            makeDateAttribute(named: "updatedAt")
        ]
        entity.uniquenessConstraints = [["page"]]
        return entity
    }

    /// Builds the entity that stores a single character and favorite state.
    private static func makeCharacterInfoEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = CharacterInfoEntity.entityName
        entity.managedObjectClassName = NSStringFromClass(CharacterInfoEntity.self)
        entity.properties = [
            makeIntegerAttribute(named: "id"),
            makeIntegerAttribute(named: "orderIndex"),
            makeStringArrayAttribute(named: "films"),
            makeStringArrayAttribute(named: "shortFilms"),
            makeStringArrayAttribute(named: "tvShows"),
            makeStringArrayAttribute(named: "videoGames"),
            makeStringArrayAttribute(named: "parkAttractions"),
            makeStringArrayAttribute(named: "allies"),
            makeStringArrayAttribute(named: "enemies"),
            makeStringAttribute(named: "name"),
            makeStringAttribute(named: "imageUrl", isOptional: true),
            makeStringAttribute(named: "url"),
            makeBoolAttribute(named: "isFavorite"),
            makeDateAttribute(named: "updatedAt")
        ]
        entity.uniquenessConstraints = [["id"]]
        return entity
    }

    // MARK: - Relationships
    
    /// Connects list pages and characters with inverse relationships.
    /// - Parameters:
    ///   - charactersListEntity: Entity that owns the page snapshot.
    ///   - characterInfoEntity: Entity stored as list content.
    private static func configureRelationships(
        charactersListEntity: NSEntityDescription,
        characterInfoEntity: NSEntityDescription
    ) {
        let charactersRelationship = NSRelationshipDescription()
        charactersRelationship.name = "characters"
        charactersRelationship.destinationEntity = characterInfoEntity
        charactersRelationship.minCount = 0
        charactersRelationship.maxCount = 0
        charactersRelationship.deleteRule = .cascadeDeleteRule
        charactersRelationship.isOptional = true

        let listRelationship = NSRelationshipDescription()
        listRelationship.name = "list"
        listRelationship.destinationEntity = charactersListEntity
        listRelationship.minCount = 0
        listRelationship.maxCount = 1
        listRelationship.deleteRule = .nullifyDeleteRule
        listRelationship.isOptional = true

        charactersRelationship.inverseRelationship = listRelationship
        listRelationship.inverseRelationship = charactersRelationship

        charactersListEntity.properties.append(charactersRelationship)
        characterInfoEntity.properties.append(listRelationship)
    }

    // MARK: - Attributes
    
    /// Creates a required Int64 attribute.
    /// - Parameter name: Attribute name inside the Core Data model.
    private static func makeIntegerAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .integer64AttributeType
        attribute.isOptional = false
        attribute.defaultValue = 0
        return attribute
    }

    /// Creates a required Bool attribute.
    /// - Parameter name: Attribute name inside the Core Data model.
    private static func makeBoolAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .booleanAttributeType
        attribute.isOptional = false
        attribute.defaultValue = false
        return attribute
    }

    /// Creates a string attribute.
    /// - Parameters:
    ///   - name: Attribute name inside the Core Data model.
    ///   - isOptional: Whether Core Data can store a nil value.
    private static func makeStringAttribute(
        named name: String,
        isOptional: Bool = false
    ) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .stringAttributeType
        attribute.isOptional = isOptional
        return attribute
    }

    /// Creates a transformable attribute for `[String]` values.
    /// - Parameter name: Attribute name inside the Core Data model.
    private static func makeStringArrayAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .transformableAttributeType
        attribute.isOptional = false
        attribute.attributeValueClassName = NSStringFromClass(NSArray.self)
        attribute.valueTransformerName = NSValueTransformerName.secureUnarchiveFromDataTransformerName.rawValue
        attribute.defaultValue = NSArray()
        return attribute
    }

    /// Creates a required Date attribute.
    /// - Parameter name: Attribute name inside the Core Data model.
    private static func makeDateAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .dateAttributeType
        attribute.isOptional = false
        return attribute
    }
}
