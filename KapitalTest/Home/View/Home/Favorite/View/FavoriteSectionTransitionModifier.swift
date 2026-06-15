//
//  FavoriteSectionTransitionModifier.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI

struct FavoriteSectionTransitionModifier: AnimatableModifier {
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(progress)
    }
}

private struct FavoriteSectionClipShape: Shape {
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path(
            CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width,
                height: rect.height * progress
            )
        )
    }
}
