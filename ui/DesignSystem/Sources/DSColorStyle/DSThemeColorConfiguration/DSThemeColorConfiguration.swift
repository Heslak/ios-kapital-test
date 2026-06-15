//
//  DSThemeColorConfiguration.swift
//  Pods
//
//  Created by Sergio Acosta on 14/06/26.
//

import Foundation
import SwiftUI

protocol DSColorConfiguration {
    func color(for style: DSColorStyle) -> DSColorPair
}

struct DSThemeColorConfiguration: DSColorConfiguration {
    func color(for style: DSColorStyle) -> DSColorPair {
        switch style {
        case .ink(let style):
            switch style {
            case .primary:
                return .init(
                    light: Color(red: 0.10, green: 0.10, blue: 0.20),
                    dark: Color(red: 1.0, green: 1.0, blue: 1.00)
                )
            case .secondary:
                return .init(
                    light: Color(red: 0.55, green: 0.55, blue: 0.63),
                    dark: Color(red: 1.0, green: 1.0, blue: 1.00)
                )
            case .favorite:
                return .init(
                    light: Color(red: 1.0, green: 0.176, blue: 0.333),
                    dark: Color(red: 1.0, green: 1.0, blue: 1.00)
                )
            case .placeholder:
                return .init(
                    light: Color(white: 1.0, opacity: 0.85),
                    dark: Color(white: 1.0, opacity: 0.85)
                )
            case .error:
                return .init(
                    light: Color(red: 0.96, green: 0.96, blue: 0.97),
                    dark: Color(red: 1.0, green: 1.0, blue: 1.00)
                )
                
            }
        case .background(let style):
            switch style {
            case .standard:
                return .init(
                    light: Color(white: 1.0),
                    dark: Color(white: 0.0)
                )
            case .character:
                return .init(
                    light: Color(red: 0.96, green: 0.96, blue: 0.97),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .favorite:
                return .init(
                    light: Color(red: 1.00, green: 0.90, blue: 0.93),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .unSelected:
                return .init(
                    light: Color(red: 0.91, green: 0.91, blue: 0.93),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .placeholder:
                return .init(
                    light: Color(white: 1.0, opacity: 0.35),
                    dark: Color(white: 1.0, opacity: 0.35)
                )
            }
        case .placeHolder(let style):
            switch style {
            case .yellow:
                return .init(
                    light: Color(red: 1.00, green: 0.84, blue: 0.56),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .green:
                return .init(
                    light: Color(red: 0.73, green: 0.89, blue: 0.75),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .pink:
                return .init(
                    light: Color(red: 0.96, green: 0.61, blue: 0.75),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .purple:
                return .init(
                    light: Color(red: 0.83, green: 0.60, blue: 0.88),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            case .cyan:
                return .init(
                    light: Color(red: 0.55, green: 0.87, blue: 0.90),
                    dark: Color(red: 0.96, green: 0.96, blue: 0.97)
                )
            }
        case .shadow(let style):
            switch style {
            case .black:
                return .init(
                    light: Color(white: 0.0, opacity: 0.05),
                    dark: Color(white: 0.0, opacity: 0.1)
                )
            }
        }
    }
}
