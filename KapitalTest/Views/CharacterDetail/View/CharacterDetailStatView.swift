//
//  CharacterDetailStatView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailStatModel: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let count: Int
    let color: DSColorStyle
}

struct CharacterDetailStatView: View {
    var iconName: String
    var color: DSColorStyle
    var count: Int
    var title: String
    
    var body: some View {
        VStack(spacing: DSDimens.spacing_1) {
            Image(systemName: iconName)
                .font(.caption1Bold)
                .foregroundStyle(color)
            
            Text("\(count)")
                .font(.h3Bold)
                .foregroundStyle(.ink(.primary))
            
            Text(title)
                .font(.caption2Bold)
                .foregroundStyle(.ink(.secondary))
        }
        .frame(maxWidth: .infinity)
    }
}
