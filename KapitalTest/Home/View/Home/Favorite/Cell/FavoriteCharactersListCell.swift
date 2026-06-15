//
//  FavoriteCharactersListCell.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
import DesignSystem

struct FavoriteCharactersListCellView: View {
    let character: CharacterInfo
    let placeholderColor: DSColorStyle.PlaceholderStyle
    
    var body: some View {
        VStack(spacing: DSDimens.spacing_3) {
            AvatarView(
                imageURL: character.imageUrl,
                placeholderColor: placeholderColor
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: DSDimens.spacing_5,
                    style: .continuous
                )
                .stroke(
                    Color(.ink(.favorite)),
                    lineWidth: DSDimens.spacing_1
                )
            )
            
            Text(character.name)
                .font(.bodyBold)
                .foregroundStyle(.ink(.primary))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .frame(maxWidth: DSSizeDimens.width_84)
        }
        .frame(width: DSSizeDimens.width_84)
    }
}

#if DEBUG
#Preview {
    FavoriteCharactersListCellView(
        character: CharacterInfo(
            id: 1,
            films: ["Hercules"],
            shortFilms: [],
            tvShows: ["Hercules"],
            videoGames: ["Kingdom Hearts"],
            parkAttractions: [],
            allies: [],
            enemies: [],
            name: "Achilles",
            imageUrl: "https://static.wikia.nocookie.net/disney/images/6/67/HATS_Achilles.png",
            url: "",
            isFavorite: true
        ),
        placeholderColor: .cyan
    )
}
#endif
