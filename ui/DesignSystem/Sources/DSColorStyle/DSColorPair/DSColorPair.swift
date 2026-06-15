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
