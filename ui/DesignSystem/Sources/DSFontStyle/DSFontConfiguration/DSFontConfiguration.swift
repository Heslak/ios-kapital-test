//
//  DSFontConfiguration.swift
//  Pods
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation
import SwiftUI

protocol DSFontConfiguration {
    func font(for style: DSFontStyle) -> Font
}

struct DSFontThemeConfiguration: DSFontConfiguration {
    func font(for style: DSFontStyle) -> Font {
        switch style {
        case .placeholder:
                .system(size: 24, weight: .bold)
        case .icon:
                .system(size: 18, weight: .bold)
        case .h1Bold:
                .system(size: 40, weight: .bold, design: .rounded)
        case .h1Regular:
                .system(size: 40, weight: .regular, design: .rounded)
        case .h1Medium:
                .system(size: 40, weight: .medium, design: .rounded)
        case .h2Bold:
                .system(size: 22, weight: .bold, design: .rounded)
        case .h2Regular:
                .system(size: 22, weight: .regular, design: .rounded)
        case .h2Medium:
                .system(size: 22, weight: .medium, design: .rounded)
        case .h3Bold:
                .system(size: 20, weight: .bold, design: .rounded)
        case .h3Regular:
                .system(size: 20, weight: .regular, design: .rounded)
        case .h3Medium:
                .system(size: 20, weight: .medium, design: .rounded)
        case .titleBold:
                .system(size: 18, weight: .bold, design: .rounded)
        case .titleRegular:
                .system(size: 18, weight: .regular, design: .rounded)
        case .titleMedium:
                .system(size: 18, weight: .medium, design: .rounded)
        case .bodyBold:
                .system(size: 16, weight: .bold, design: .rounded)
        case .bodyRegular:
                .system(size: 16, weight: .regular, design: .rounded)
        case .bodyMedium:
                .system(size: 16, weight: .medium, design: .rounded)
        case .caption1Bold:
                .system(size: 14, weight: .bold, design: .rounded)
        case .caption1Regular:
                .system(size: 14, weight: .regular, design: .rounded)
        case .caption1Medium:
                .system(size: 14, weight: .medium, design: .rounded)
        case .caption2Bold:
                .system(size: 12, weight: .bold, design: .rounded)
        case .caption2Regular:
                .system(size: 12, weight: .regular, design: .rounded)
        case .caption2Medium:
                .system(size: 12, weight: .medium, design: .rounded)
        case .labelBold:
                .system(size: 10, weight: .bold, design: .rounded)
        case .labelRegular:
                .system(size: 10, weight: .regular, design: .rounded)
        case .labelMedium:
                .system(size: 10, weight: .medium, design: .rounded)
        }
    }
}
