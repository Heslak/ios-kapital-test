//
//  HomeTitleView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI
import DesignSystem

struct HomeTitleView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSDimens.spacing_1) {
            Text("DISNEY UNIVERSE")
                .font(.h3Bold)
                .foregroundStyle(.ink(.secondary))
                .tracking(2)
            
            Text("Characters")
                .font(.h1Bold)
                .foregroundStyle(.ink(.primary))
        }
        .padding(.top, DSDimens.spacing_7)
    }
}

#if DEBUG
#Preview {
    HomeTitleView()
}
#endif
