//
//  DSColorFactory.swift
//  Pods
//
//  Created by Sergio Acosta on 14/06/26.
//

import Foundation
import SwiftUI
import UIKit

struct DSColorFactory {
    
    static let shared = DSColorFactory()
    let config: DSColorConfiguration = DSThemeColorConfiguration()
    
    func color(for style: DSColorStyle) -> Color {
        let codes = config.color(for: style)
        
        return Color(
            uiColor: UIColor { traitCollection in
                UIColor(
                    traitCollection.userInterfaceStyle == .dark ?
                    codes.dark ?? codes.light :
                    codes.light
                )
            }
        )
    }
}
