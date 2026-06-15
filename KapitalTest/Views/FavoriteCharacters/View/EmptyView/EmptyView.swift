//
//  EmptyView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct EmptyView: View {
    
    var title: String
    var subtitle: String
    var descriptionTitle: String
    var description: String
    
    var body: some View {
        VStack(spacing: DSDimens.spacing_4) {
            HomeTitleView(
                title: title,
                subtitle: subtitle
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Image(systemName: "suit.heart")
                .font(.h1Bold)
                .foregroundStyle(.ink(.secondary))
            
            Text(descriptionTitle)
                .font(.h2Bold)
                .foregroundStyle(.ink(.primary))
            
            Text(description)
                .font(.bodyMedium)
                .foregroundStyle(.ink(.secondary))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(DSDimens.spacing_5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
#Preview {
    EmptyView(
        title: AppStrings.appEyebrow,
        subtitle: AppStrings.favoritesTitle,
        descriptionTitle: AppStrings.noFavoritesTitle,
        description: AppStrings.noFavoritesDescription
    )
}
#endif
