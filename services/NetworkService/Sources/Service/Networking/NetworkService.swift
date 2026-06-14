//
//  NetworkService.swift
//  NetworkService
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

// MARK: - Network Client
actor NetworkService: NetworkServiceInterface {
    private let session: URLSession
    
    init(session: URLSession = NetworkService.makeDefaultSession()) {
        self.session = session
    }
    
    // Static factory method to generate a highly configured URLSession
    private static func makeDefaultSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        
        // 1. Configure Custom Timeouts
        configuration.timeoutIntervalForRequest = 30.0 // 30 seconds
        configuration.timeoutIntervalForResource = 60.0 // 60 seconds
        configuration.httpMaximumConnectionsPerHost = 5
        
        // 2. Configure Custom URLCache Capacities
        // 50 MB Memory Cache, 100 MB Disk Cache
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let customCache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "com.app.network.cache"
        )
        
        configuration.urlCache = customCache
        
        return URLSession(configuration: configuration)
    }
    
    // MARK: - Generic Request Function
    func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        
        let request = try createURLRequest(from: endpoint)
        
        if let cachedResponse = session.configuration.urlCache?.cachedResponse(for: request) {
            if let decoded = try? JSONDecoder().decode(T.self, from: cachedResponse.data) {
                return decoded
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        let cachedData = CachedURLResponse(response: httpResponse, data: data)
        session.configuration.urlCache?.storeCachedResponse(cachedData, for: request)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func createURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.cachePolicy = endpoint.cachePolicy
        
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
