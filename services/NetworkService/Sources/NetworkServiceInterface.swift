//
//  NetworkServiceInterface.swift
//  NetworkServiceInterface
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

public struct NetworkServiceFactory {
    /// Creates the default URLSession-backed network service.
    public static func makeNetworkService() -> NetworkServiceInterface {
        return NetworkService()
    }
}

public protocol NetworkServiceInterface {
    /// Executes an endpoint and decodes the response into the requested type.
    /// - Parameter endpoint: API endpoint that provides URL, method, headers and cache policy.
    func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
