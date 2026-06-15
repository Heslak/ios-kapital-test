//
//  CharacterTagView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
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
            return "\(count) film"
        case .show(let count):
            return "\(count) show"
        case .game(let count):
            return "\(count) game"
        case .attractions(let count):
            return "\(count) attractions"
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
}

struct CharacterTagView: View {
    let type: CharacterTagViewType
    
    var body: some View {
        HStack(spacing: DSDimens.spacing_2) {
            Image(systemName: type.iconName)
                .font(.caption2Bold)
            
            Text(type.title)
                .font(.caption2Bold)
                .lineLimit(1)
        }
        .foregroundStyle(.ink(.secondary))
    }
}

#if DEBUG
#Preview {
    CharacterTagView(
        type: .attractions(count: 1)
    )
}
#endif
