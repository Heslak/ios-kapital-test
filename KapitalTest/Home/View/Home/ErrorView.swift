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
            Text("Error")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.ink(.primary))
            
            Button("Retry") {
                Task {
                    await action()
                }
            }
            .font(.system(size: 17, weight: .bold, design: .rounded))
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
