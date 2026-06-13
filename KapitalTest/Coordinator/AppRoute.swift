//
//  AppRoute.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 12/06/26.
//

enum AppRoute: Hashable, Identifiable {
    case home
    case detail(item: String)
    
    var id: String {
        switch self {
        case .home: return "home"
        case .detail(let item): return "detail-\(item)"
        }
    }
}
