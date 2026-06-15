//
//  LocalStorageModelFactory.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import CoreData
import Foundation

enum LocalStorageModelFactory {
    static let modelName = "LocalStorageModel"

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

    private static func makeIntegerAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .integer64AttributeType
        attribute.isOptional = false
        attribute.defaultValue = 0
        return attribute
    }

    private static func makeBoolAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .booleanAttributeType
        attribute.isOptional = false
        attribute.defaultValue = false
        return attribute
    }

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

    private static func makeDateAttribute(named name: String) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = .dateAttributeType
        attribute.isOptional = false
        return attribute
    }
}
