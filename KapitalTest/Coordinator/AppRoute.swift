//
//  AppRoute.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

enum AppRoute: Hashable, Identifiable {
    case home
    case detail(id: Int)
    
    var id: String {
        switch self {
        case .home: return "home"
        case .detail(let id): return "detail-\(id)"
        }
    }
}
