//
//  NetworkServiceInterface.swift
//  NetworkServiceInterface
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

public struct NetworkServiceFactory {
    public static func makeNetworkService() -> NetworkServiceInterface {
        return NetworkService()
    }
}

public protocol NetworkServiceInterface {
    func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
