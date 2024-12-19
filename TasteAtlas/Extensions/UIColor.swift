//
//  UIColor.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/15.
//

import UIKit

extension UIColor {
    
    static let darkGrey = UIColor(hex: "222222")
    static let primaryDarkGreen = UIColor(hex: "1E201E")
    static let secondaryDarkGreen = UIColor(hex: "3C3D37")
    static let primaryGreen = UIColor(hex: "697565")
    static let primaryEarth = UIColor(hex: "ECDFCC")
    static let signInButtonGray = UIColor(hex: "EFEFEF")
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        let hexStart = hex[hex.startIndex] == "#"
        let current = String.Index(utf16Offset: hexStart ? 1 : 0, in: hex)
        scanner.currentIndex = current
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat((rgb & 0xFF)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    var isLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let r = components[0] * 299
        let b = components[1] * 587
        let g = components[2] * 114
        let brightness = (r + b + g) / 1000
        return brightness > 0.7
    }
}
