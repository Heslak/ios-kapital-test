//
//  CharacterTagView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
import DesignSystem

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
