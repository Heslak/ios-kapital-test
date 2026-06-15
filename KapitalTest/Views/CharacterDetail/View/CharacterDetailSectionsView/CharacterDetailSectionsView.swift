//
//  CharacterDetailSectionsView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailSectionsView: View {
    let character: CharacterInfo
        
    var body: some View {
        let sections = character.getStatsSection()
        VStack(spacing: DSDimens.spacing_5) {
            ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                CharacterDetailSectionView(section: section)
                
                if index < sections.count - 1 {
                    Divider()
                }
            }
        }
        .padding(DSDimens.spacing_5)
        .background(.background(.standard))
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSDimens.spacing_5,
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
}
