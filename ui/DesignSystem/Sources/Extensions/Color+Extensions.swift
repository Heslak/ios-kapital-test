//
//  Color+Extensions.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 14/06/26.
//

import SwiftUI

public extension Color {
    init(_ style: DSColorStyle) {
        self = DSColorFactory.shared.color(for: style)
    }
}
