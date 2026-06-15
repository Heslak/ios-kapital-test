//
//  ErrorView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct ErrorView: View {
    
    var action: @Sendable () async -> Void
        
    var body: some View {
        VStack(spacing: DSDimens.spacing_5) {
            Text(AppStrings.errorTitle)
                .font(.h2Bold)
                .foregroundStyle(.ink(.primary))
            
            Button(AppStrings.retryButton) {
                Task {
                    await action()
                }
            }
            .font(.bodyBold)
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
#Preview {
    ErrorView(action: {})
}
#endif
