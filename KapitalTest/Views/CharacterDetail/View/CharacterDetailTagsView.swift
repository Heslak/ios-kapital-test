//
//  CharacterDetailTagsView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailTagsView: View {
    let character: CharacterInfo
    
    var body: some View {
        let tags = character.getTags()
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSDimens.spacing_3) {
                ForEach(tags) { tag in
                    Text(tag.detailTitle)
                        .font(.caption1Bold)
                        .foregroundStyle(tag.color)
                        .padding(.horizontal, DSDimens.spacing_4)
                        .padding(.vertical, DSDimens.spacing_3)
                        .background(tag.background)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, DSDimens.spacing_3)
        }
        .padding(.horizontal, -DSDimens.spacing_3)
    }
}
