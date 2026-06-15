//
//  LocalStorageCoreDataStack.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import CoreData
import Foundation

// MARK: - Core Data Stack

final class LocalStorageCoreDataStack {
    private let container: NSPersistentContainer
    private var loadingError: Error?

    /// Builds the persistent container used by the local storage service.
    /// - Parameters:
    ///   - storeType: Core Data store type. Tests can inject `NSInMemoryStoreType`.
    ///   - storeURL: Optional explicit store URL. Defaults to Application Support.
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

    // MARK: - Context Execution
    
    /// Runs a synchronous operation against the view context and rethrows any Core Data error.
    /// - Parameter operation: Closure that receives the configured managed object context.
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

    // MARK: - Store Location
    
    /// Returns the default SQLite store location inside Application Support.
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
