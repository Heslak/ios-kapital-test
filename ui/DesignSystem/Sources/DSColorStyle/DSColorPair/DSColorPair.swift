//
//  DSColorPair.swift
//  Pods
//
//  Created by Sergio Acosta on 14/06/26.
//

import Foundation
import SwiftUI

struct DSColorPair {
    let light: Color
    let dark: Color?
    
    init(light: Color, dark: Color?) {
        self.light = light
        self.dark = dark
    }
}

extension DSColorPair {
    init(_ style: DSColorStyle.InkStyle) {
        switch style {
        case .primary:
            self = .init(
                light: Color(red: 0.10, green: 0.10, blue: 0.20),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .secondary:
            self = .init(
                light: Color(red: 0.55, green: 0.55, blue: 0.63),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .favorite:
            self = .init(
                light: Color(red: 1.0, green: 0.176, blue: 0.333),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .placeholder:
            self = .init(
                light: Color(white: 1.0, opacity: 0.85),
                dark: Color(white: 1.0, opacity: 0.85)
            )
        case .error:
            self = .init(
                light: Color(red: 0.96, green: 0.96, blue: 0.97),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .film:
            self = .init(
                light: Color(red: 0.00, green: 0.42, blue: 1.00),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .show:
            self = .init(
                light: Color(red: 1.00, green: 0.48, blue: 0.10),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .game:
            self = .init(
                light: Color(red: 0.13, green: 0.76, blue: 0.30),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .attraction:
            self = .init(
                light: Color(red: 1.00, green: 0.18, blue: 0.33),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .allies:
            self = .init(
                light: Color(red: 0.20, green: 0.72, blue: 0.80),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        case .enemies:
            self = .init(
                light: Color(red: 0.45, green: 0.40, blue: 1.00),
                dark: Color(red: 1.0, green: 1.0, blue: 1.00)
            )
        }
    }
    
    init (_ style: DSColorStyle.PlaceholderStyle) {
        switch style {
        case .yellow:
            self = .init(
                light: Color(red: 1.00, green: 0.84, blue: 0.56),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .green:
            self = .init(
                light: Color(red: 0.73, green: 0.89, blue: 0.75),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .pink:
            self = .init(
                light: Color(red: 0.96, green: 0.61, blue: 0.75),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .purple:
            self = .init(
                light: Color(red: 0.83, green: 0.60, blue: 0.88),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .cyan:
            self = .init(
                light: Color(red: 0.55, green: 0.87, blue: 0.90),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .blue:
            self = .init(
                light: Color(red: 0.90, green: 0.94, blue: 1.00),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .orange:
            self = .init(
                light: Color(red: 1.00, green: 0.93, blue: 0.86),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        }
    }
    
    init (_ style: DSColorStyle.BackgroundStyle) {
        switch style {
        case .standard:
            self = .init(
                light: Color(white: 1.0),
                dark: Color(white: 0.0)
            )
        case .character:
            self = .init(
                light: Color(red: 0.96, green: 0.96, blue: 0.97),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .favorite:
            self = .init(
                light: Color(red: 1.00, green: 0.90, blue: 0.93),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .unSelected:
            self = .init(
                light: Color(red: 0.91, green: 0.91, blue: 0.93),
                dark: Color(red: 0.96, green: 0.96, blue: 0.97)
            )
        case .placeholder:
            self = .init(
                light: Color(white: 1.0, opacity: 0.35),
                dark: Color(white: 1.0, opacity: 0.35)
            )
        }
    }
    
    init(_ style: DSColorStyle.ShadowStyle) {
        switch style {
        case .black:
            self = .init(
                light: Color(white: 0.0, opacity: 0.05),
                dark: Color(white: 0.0, opacity: 0.1)
            )
        }
    }
}
