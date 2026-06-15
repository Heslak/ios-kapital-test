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
            
            Text("Loading")
                .font(.system(size: 18, weight: .bold, design: .rounded))
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
