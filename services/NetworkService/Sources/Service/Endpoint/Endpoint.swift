//
//  Endpoint.swift
//  Pods
//
//  Created by Sergio Acosta on 12/06/26.
//

import Foundation

public enum Endpoint {
    // Base URL
    private static let baseURL = "https://api.disneyapi.dev/"
    
    case fetchList(page: Int)
    case fetchDetail(id: String)
    
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
    
    var method: HTTPMethod {
        switch self {
        case .fetchList: return .get
        case .fetchDetail: return .post
        }
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        switch self {
        case .fetchList, .fetchDetail:
            return .useProtocolCachePolicy
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchList, .fetchDetail:
            return nil
        }
    }
}
