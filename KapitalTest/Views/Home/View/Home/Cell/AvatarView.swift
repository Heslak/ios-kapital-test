//
//  AvatarView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
import DesignSystem

struct AvatarView: View {
    let imageURL: String?
    let placeholderColor: DSColorStyle.PlaceholderStyle
    
    var body: some View {
        buildPlaceholder()
            .remoteImage(
                urlString: imageURL,
                targetSize: CGSize(
                    width: DSSizeDimens.width_72,
                    height: DSSizeDimens.height_72
                )
            )
            .frame(
                width: DSSizeDimens.width_72,
                height: DSSizeDimens.height_72
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSDimens.spacing_5,
                    style: .continuous
                )
            )
            .clipped()
    }
    
    @ViewBuilder
    private func buildPlaceholder() -> some View {
        ZStack {
            placeholderColor.style.color
            
            Image(systemName: "photo")
                .font(.placeholder)
                .foregroundStyle(.ink(.placeholder))
                .frame(
                    width: DSSizeDimens.width_56,
                    height: DSSizeDimens.height_56
                )
                .background(.background(.placeholder))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: DSDimens.spacing_3,
                        style: .continuous
                    )
                )
        }
    }
}

#if DEBUG
#Preview {
    AvatarView(
        imageURL: "https://static.wikia.nocookie.net/disney/images/6/67/HATS_Achilles.png",
        placeholderColor: .cyan
    )
}
#endif
