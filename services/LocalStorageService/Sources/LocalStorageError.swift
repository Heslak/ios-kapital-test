//
//  LocalStorageError.swift
//  LocalStorageService
//
//  Created by Sergio Acosta on 14/06/26.
//

import Foundation

public enum LocalStorageError: Error {
    case storeUnavailable(Error)
    case contextUnavailable
    case invalidEntity(String)
    case charactersListNotFound(page: Int)
    case characterNotFound(id: Int)
}
