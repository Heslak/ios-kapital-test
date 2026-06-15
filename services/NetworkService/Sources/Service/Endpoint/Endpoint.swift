//
//  Endpoint.swift
//  Pods
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

// MARK: - Disney API Endpoint

public enum Endpoint {
    private static let baseURL = "https://api.disneyapi.dev/"
    
    case fetchList(page: Int)
    case fetchDetail(id: String)
    
    // MARK: - URL
    
    /// Builds the final API URL for the selected endpoint.
    var url: URL? {
        
        var components = URLComponents(string: Endpoint.baseURL)
        
        switch self {
        case .fetchList(let page):
            components?.path = "/character"
            components?.queryItems = [URLQueryItem(name: "page", value: String(page))]
        case .fetchDetail(let id):
            components?.path = "/character/\(id)"
        }
        
        return components?.url
    }
    
    // MARK: - Request Configuration
    
    /// HTTP method used by the endpoint.
    var method: HTTPMethod {
        switch self {
        case .fetchList, .fetchDetail: return .get
        }
    }
    
    /// Default headers sent with every Disney API request.
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    /// Cache policy used by URLSession for the endpoint request.
    var cachePolicy: NSURLRequest.CachePolicy {
        switch self {
        case .fetchList, .fetchDetail:
            return .useProtocolCachePolicy
        }
    }
    
    /// HTTP body for the endpoint. Current Disney API requests are body-less.
    var body: Data? {
        switch self {
        case .fetchList, .fetchDetail:
            return nil
        }
    }
}
