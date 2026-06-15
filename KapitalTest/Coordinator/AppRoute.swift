//
//  AppRoute.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

// MARK: - App Route

enum AppRoute: Hashable, Identifiable {
    case home
    case detail(id: Int)
    
    /// Stable route identifier used by SwiftUI navigation.
    var id: String {
        switch self {
        case .home: return "home"
        case .detail(let id): return "detail-\(id)"
        }
    }
}
