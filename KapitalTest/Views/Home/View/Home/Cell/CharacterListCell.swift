//
//  CharacterListCell.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterListCell: View {
    let character: CharacterInfo
    let favoriteAction: (CharacterInfo) -> Void
    
    var body: some View {
        HStack(spacing: DSDimens.spacing_3) {
            buildBody()
        }
        .padding(DSDimens.spacing_3)
        .background(.background(.standard))
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSDimens.spacing_6,
                style: .continuous
            )
        )
        .shadow(
            color: Color(.shadow(.black)),
            radius: DSDimens.spacing_3,
            x: 0,
            y: 5
        )
    }
    
    @ViewBuilder
    private func buildBody() -> some View {
        HStack(spacing: DSDimens.spacing_3) {
            buildAvatarView()
            
            VStack(alignment: .leading, spacing: DSDimens.spacing_3) {
                buildContentCell()
            }
            .frame(maxWidth: .infinity)
        }
        
        buildFavoriteView()
        
        Image(systemName: "chevron.right")
            .font(.icon)
            .foregroundStyle(.ink(.primary))
    }
    
    @ViewBuilder
    private func buildAvatarView() -> some View {
        AvatarView(
            imageURL: character.imageUrl,
            placeholderColor: character.placeholderColor
        )
    }
    
    @ViewBuilder
    func buildContentCell() -> some View {
        Text(character.name)
            .font(.titleBold)
            .foregroundColor(.ink(.primary))
            .lineLimit(1)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSDimens.spacing_3) {
                ForEach(character.getTags(), id: \.id) { tag in
                    CharacterTagView(type: tag)
                }
            }
        }
    }
    
    @ViewBuilder
    func buildFavoriteView() -> some View {
        CharacterFavoriteView(
            isFavorite: character.isFavorite,
            action: {
                favoriteAction(character)
            }
        )
    }
}

#if DEBUG
#Preview {
    CharacterListCell(
        character: .getMockCharacter(),
        favoriteAction: { _ in }
    )
}
#endif
