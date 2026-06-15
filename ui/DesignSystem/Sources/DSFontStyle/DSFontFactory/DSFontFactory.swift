//
//  DSFontFactory.swift
//  Pods
//
//  Created by Sergio Acosta on 15/06/26.
//

import Foundation
import SwiftUI

struct DSFontFactory {
    
    static let shared = DSFontFactory()
    
    let config: DSFontConfiguration = DSFontThemeConfiguration()
    
    func font(for style: DSFontStyle) -> Font {
        return config.font(for: style)
    }
}
