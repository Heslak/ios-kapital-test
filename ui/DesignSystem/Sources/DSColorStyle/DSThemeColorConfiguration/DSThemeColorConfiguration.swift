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
            return DSColorPair(style)
        case .background(let style):
            return DSColorPair(style)
        case .placeholder(let style):
            return DSColorPair(style)
        case .shadow(let style):
            return DSColorPair(style)
        }
    }
}
