//
//  DSColorStyle+Extensions.swift
//  Pods
//
//  Created by Sergio Acosta on 14/06/26.
//

import Foundation
import SwiftUI

public extension DSColorStyle {
    var color: Color { DSColorFactory.shared.color(for: self) }
    
    enum InkStyle {
        case primary
        case secondary
        case favorite
        case placeholder
        case error
        public var style: DSColorStyle { .ink(self) }
    }
    
    enum BackgroundStyle {
        case character
        case standard
        case favorite
        case unSelected
        case placeholder
        public var style: DSColorStyle { .background(self) }
    }
    
    enum PlaceholderStyle {
        case yellow
        case green
        case pink
        case purple
        case cyan
        public var style: DSColorStyle { .placeHolder(self) }
    }
    
    enum ShadowStyle {
        case black
        public var style: DSColorStyle { .shadow(self) }
    }
}
