//
//  CharacterDetailHeaderView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailHeaderView: View {
    let character: CharacterInfo
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: DSDimens.spacing_5) {
                builImageView()
                
                builInfoViews()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSDimens.spacing_8)
            .padding(.horizontal, DSDimens.spacing_5)
            
            buildBadge()
        }
        .background(character.placeholderColor.style.color)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSDimens.spacing_6,
                style: .continuous
            )
        )
    }
    
    private func builImageView() -> some View {
        ZStack {
            character.placeholderColor.style.color
            
            Image(systemName: "photo")
                .font(.placeholder)
                .foregroundStyle(.ink(.placeholder))
                .frame(
                    width: DSSizeDimens.width_84,
                    height: DSSizeDimens.height_84
                )
                .background(.background(.placeholder))
        }
        .remoteImage(
            urlString: character.imageUrl,
            targetSize: CGSize(
                width: DSSizeDimens.width_120,
                height: DSSizeDimens.height_120
            )
        )
        .frame(
            width: DSSizeDimens.width_120,
            height: DSSizeDimens.height_120
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSDimens.spacing_7,
                style: .continuous
            )
        )
    }
    
    private func builInfoViews() -> some View {
        VStack(spacing: DSDimens.spacing_3) {
            Text(character.name)
                .font(.h2Bold)
                .foregroundStyle(.ink(.primary))
                .multilineTextAlignment(.center)
            
            HStack(spacing: DSDimens.spacing_2) {
                Image(systemName: "sparkles")
                    .font(.caption2Bold)
                
                Text(AppStrings.disneyCharacterTitle)
                    .font(.caption1Medium)
            }
            .foregroundStyle(.ink(.secondary))
        }
    }
    
    private func buildBadge() -> some View {
        Text("#\(character.id)")
            .font(.caption1Bold)
            .foregroundStyle(.ink(.secondary))
            .padding(.horizontal, DSDimens.spacing_3)
            .padding(.vertical, DSDimens.spacing_2)
            .background(.background(.placeholder))
            .clipShape(Capsule())
            .padding(DSDimens.spacing_4)
    }
}

#if DEBUG
#Preview {
    CharacterDetailHeaderView(
        character: .getMockCharacter()
    )
}
#endif
