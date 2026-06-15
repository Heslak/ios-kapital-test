//
//  CharacterFavoriteView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterFavoriteView: View {
    let isFavorite: Bool
    let action: () -> Void
    
    private var backgrounColor: DSColorStyle.BackgroundStyle {
        return isFavorite ? .favorite : .character
    }
    
    private var heartColor: DSColorStyle.InkStyle {
        return isFavorite ? .favorite : .secondary
    }
    
    private var imageName: String {
        return isFavorite ? "suit.heart.fill" : "suit.heart"
    }
    
    var body: some View {
        Button(action: action) {
            buildImage()
                .padding(DSDimens.spacing_3)
                .background(backgrounColor.style.color)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(AppStrings.favoriteAccessibilityLabel))
    }
    
    private func buildImage() -> some View {
        Image(systemName: imageName)
            .font(.caption1Bold)
            .foregroundStyle(heartColor.style.color)
            .frame(
                width: DSSizeDimens.width_20,
                height: DSSizeDimens.height_20
            )
    }
}

#if DEBUG
#Preview {
    CharacterFavoriteView(
        isFavorite: false,
        action: { }
    )
}
#endif
