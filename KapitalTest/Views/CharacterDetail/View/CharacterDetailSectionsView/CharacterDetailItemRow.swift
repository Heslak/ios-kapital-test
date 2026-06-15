//
//  CharacterDetailItemRow.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailItemRow: View {
    let index: Int
    let title: String
    let color: DSColorStyle
    let background: DSColorStyle
    
    var body: some View {
        HStack(spacing: DSDimens.spacing_4) {
            Text("\(index)")
                .font(.caption1Bold)
                .foregroundStyle(color)
                .frame(
                    width: DSSizeDimens.width_28,
                    height: DSSizeDimens.height_28
                )
                .background(background)
                .clipShape(Circle())
            
            Text(title)
                .font(.bodyBold)
                .foregroundStyle(.ink(.primary))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#if DEBUG
#Preview {
    CharacterDetailItemRow(
        index: 0,
        title: AppStrings.filmsTitle,
        color: .ink(.film),
        background: .placeholder(.blue)
    )
}
#endif
