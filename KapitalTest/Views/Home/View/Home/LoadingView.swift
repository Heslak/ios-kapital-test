//
//  LoadingView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct LoadingView: View {
    var body: some View {
        VStack(spacing: DSDimens.spacing_5) {
            ProgressView()
            
            Text(AppStrings.loadingTitle)
                .font(.h3Bold)
                .foregroundStyle(.ink(.secondary))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
#Preview {
    LoadingView()
}
#endif
