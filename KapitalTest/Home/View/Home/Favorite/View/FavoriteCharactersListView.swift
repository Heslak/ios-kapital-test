//
//  FavoriteCharactersListView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct FavoriteCharactersListView: View {
    let characters: [CharacterInfo]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSDimens.spacing_4) {
            buildHeaderView()
            buildCharactersScrollView()
        }
        .animation(.smooth, value: characters.map(\.id))
    }
    
    @ViewBuilder
    func buildHeaderView() -> some View {
        HStack(spacing: DSDimens.spacing_3) {
            Image(systemName: "suit.heart.fill")
                .font(.h3Bold)
                .foregroundStyle(.ink(.favorite))
            
            Text("Favorites")
                .font(.h3Bold)
                .foregroundStyle(.ink(.primary))
            
            Text("\(characters.count)")
                .font(.caption1Bold)
                .foregroundStyle(.ink(.favorite))
                .frame(
                    width: DSSizeDimens.width_20,
                    height: DSSizeDimens.height_20
                )
                .background(.background(.favorite))
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    func buildCharactersScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: DSDimens.spacing_3) {
                ForEach(characters, id: \.id) { character in
                    FavoriteCharactersListCellView(
                        character: character,
                        placeholderColor: character.placeholderColor()
                    )
                }
            }
            .padding(.horizontal, DSDimens.spacing_5)
        }
        .padding(.horizontal, -DSDimens.spacing_5)
    }
}

#if DEBUG
#Preview {
    FavoriteCharactersListView(
        characters: [
            CharacterInfo(
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
            CharacterInfo(
                id: 2,
                films: ["Hercules"],
                shortFilms: [],
                tvShows: ["Hercules"],
                videoGames: [],
                parkAttractions: [],
                allies: [],
                enemies: [],
                name: "Hercules",
                imageUrl: nil,
                url: "",
                isFavorite: true
            )
        ]
    )
}
#endif
