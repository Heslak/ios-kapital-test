//
//  DSColorFactory.swift
//  Pods
//
//  Created by Sergio Acosta on 14/06/26.
//

import Foundation
import SwiftUI

struct DSColorFactory {
    
    static let shared = DSColorFactory()
    let config: DSColorConfiguration = DSThemeColorConfiguration()
    
    func color(for style: DSColorStyle) -> Color {
        let currentStyle = UIScreen.main.traitCollection.userInterfaceStyle
        let codes = config.color(for: style)
        return currentStyle == .dark ?
        codes.dark ?? codes.light :
        codes.light
    }
}
