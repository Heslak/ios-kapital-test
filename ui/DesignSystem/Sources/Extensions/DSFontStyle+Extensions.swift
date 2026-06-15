//
//  DSFontStyle.swift
//  Pods
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI

public extension DSFontStyle {
    var font: Font { DSFontFactory.shared.font(for: self) }
}
