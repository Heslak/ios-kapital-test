//
//  CharacterTagViewType.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import DesignSystem

enum CharacterTagViewType: Hashable, Identifiable {
    var id: String {
        UUID().uuidString
    }
    
    case film(count: Int)
    case show(count: Int)
    case game(count: Int)
    case attractions(count: Int)
    
    var title: String {
        switch self {
        case .film(let count):
            return AppStrings.filmCount(count)
        case .show(let count):
            return AppStrings.showCount(count)
        case .game(let count):
            return AppStrings.gameCount(count)
        case .attractions(let count):
            return AppStrings.attractionCount(count)
        }
    }
    
    var detailTitle: String {
        switch self {
        case .film:
            return AppStrings.featureFilmTag
        case .show:
            return AppStrings.tvSeriesTag
        case .game:
            return AppStrings.videoGameTag
        case .attractions:
            return AppStrings.parkAttractionTag
        }
    }
    
    var iconName: String {
        switch self {
        case .film:
            return "film"
        case .show:
            return "tv"
        case .game:
            return "gamecontroller"
        case .attractions:
            return "sparkles.tv"
        }
    }
    
    var color: DSColorStyle {
        switch self {
        case .film:
            return .ink(.film)
        case .show:
            return .ink(.show)
        case .game:
            return .ink(.game)
        case .attractions:
            return .ink(.attraction)
        }
    }
    
    var background: DSColorStyle {
        switch self {
        case .film:
            return .placeholder(.blue)
        case .show:
            return .placeholder(.orange)
        case .game:
            return .placeholder(.green)
        case .attractions:
            return .placeholder(.pink)
        }
    }
}
