//
//  View+Extensions.swift
//  Pods
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI

public extension View {
    func foregroundColor(_ style: DSColorStyle) -> some View {
        modifier(DSViewForegroundColorModifier(style: style))
    }
    
    func foregroundStyle(_ style: DSColorStyle) -> some View {
        modifier(DSViewForegroundStyleModifier(style: style))
    }
    
    func background(_ style: DSColorStyle) -> some View {
        modifier(DSViewBackgroundColorModifier(style: style))
    }
    
    func font(_ font: DSFontStyle) -> some View {
        modifier(DSFontUIModifier(style: font))
    }
    
    func remoteImage(
        urlString: String?,
        targetSize: CGSize,
        imageLoader: any DSImageLoading = DSImageLoader.shared
    ) -> some View {
        modifier(
            DSRemoteImageModifier(
                urlString: urlString,
                targetSize: targetSize,
                imageLoader: imageLoader
            )
        )
    }
}

private struct DSViewForegroundColorModifier: ViewModifier {
    
    let style: DSColorStyle
    
    func body(content: Content) -> some View {
        return content.foregroundColor(
            DSColorFactory.shared.color(
                for: style
            )
        )
    }
}

private struct DSViewForegroundStyleModifier: ViewModifier {
    
    let style: DSColorStyle
    
    func body(content: Content) -> some View {
        return content.foregroundStyle(
            DSColorFactory.shared.color(
                for: style
            )
        )
    }
}

private struct DSViewBackgroundColorModifier: ViewModifier {
    
    let style: DSColorStyle
    
    func body(content: Content) -> some View {
        return content.background(
            DSColorFactory.shared.color(
                for: style
            )
        )
    }
}
private struct DSFontUIModifier: ViewModifier {
    
    let style: DSFontStyle
    
    func body(content: Content) -> some View {
        content
            .font(
                DSFontFactory.shared.font(
                    for: style
                )
            )
    }
}

private struct DSRemoteImageModifier: ViewModifier {
    let urlString: String?
    let targetSize: CGSize
    let imageLoader: any DSImageLoading
    
    @Environment(\.displayScale) private var displayScale
    @State private var image: UIImage?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .task(id: urlString) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        image = nil
        
        guard let urlString,
              let url = URL(string: urlString) else {
            return
        }
        
        do {
            let loadedImage = try await imageLoader.loadImage(
                from: url,
                targetSize: targetSize,
                scale: displayScale
            )
            
            guard !Task.isCancelled else { return }
            
            image = loadedImage
        } catch {
            guard !Task.isCancelled else { return }
            
            image = nil
        }
    }
}
