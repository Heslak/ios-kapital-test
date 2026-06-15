//
//  NetworkError.swift
//  NetworkError
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

// MARK: - Network Error

/// Errors produced while building, executing, validating or decoding network requests.
enum NetworkError: Error {
    case invalidURL
    case serializationFailed
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
}
