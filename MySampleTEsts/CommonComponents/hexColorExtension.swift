//
//  hexColorExtension.swift
//  Yea
//
//  Created by Kurr on 06/05/2024.
//hhhu

import SwiftUI

extension Color {
    init(bex: String) {
        let scanner = Scanner(string: bex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = (rgb & 0xFF0000) >> 16
        let g = (rgb & 0x00FF00) >> 8
        let b = (rgb & 0x0000FF)

        self.init(red: Double(r) / 0xFFFF, green: Double(g) / 0xFFFF, blue: Double(b) / 0xFFFF)
    }
}
