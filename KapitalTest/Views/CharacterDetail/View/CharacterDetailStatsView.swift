//
//  CharacterDetailStatsView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailStatsView: View {
    let character: CharacterInfo
    
    var body: some View {
        HStack(spacing: DSDimens.spacing_0) {
            let stats = character.getStats()
            ForEach(stats) { stat in
                CharacterDetailStatView(
                    iconName: stat.iconName,
                    color: stat.color,
                    count: stat.count,
                    title: stat.title
                )
                
                if stat.id != stats.last?.id {
                    Divider()
                }
            }
        }
        .padding(.vertical, DSDimens.spacing_4)
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

#if DEBUG
#Preview {
    CharacterDetailStatsView(
        character: .getMockCharacter()
    )
}
#endif
