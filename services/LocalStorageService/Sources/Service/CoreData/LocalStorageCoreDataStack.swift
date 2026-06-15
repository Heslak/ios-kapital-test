//
//  LocalStorageCoreDataStack.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import CoreData
import Foundation

final class LocalStorageCoreDataStack {
    private let container: NSPersistentContainer
    private var loadingError: Error?

    init(
        storeType: String = NSSQLiteStoreType,
        storeURL: URL? = nil
    ) {
        container = NSPersistentContainer(
            name: LocalStorageModelFactory.modelName,
            managedObjectModel: LocalStorageModelFactory.makeModel()
        )

        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = storeType
        storeDescription.url = storeURL ?? Self.defaultStoreURL()
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { [weak self] _, error in
            self?.loadingError = error
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func performAndWait<T>(_ operation: (NSManagedObjectContext) throws -> T) throws -> T {
        if let loadingError {
            throw LocalStorageError.storeUnavailable(loadingError)
        }

        var value: T?
        var operationError: Error?
        container.viewContext.performAndWait {
            do {
                value = try operation(container.viewContext)
            } catch {
                operationError = error
            }
        }

        if let operationError {
            throw operationError
        }

        guard let value else {
            throw LocalStorageError.contextUnavailable
        }
        return value
    }

    private static func defaultStoreURL() -> URL {
        let fileManager = FileManager.default
        let applicationSupportURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        let directoryURL = applicationSupportURL.appendingPathComponent(
            "LocalStorageService",
            isDirectory: true
        )

        try? fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        return directoryURL.appendingPathComponent("LocalStorage.sqlite")
    }
}
