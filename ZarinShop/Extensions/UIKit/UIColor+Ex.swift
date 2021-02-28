//
//  UIColor+Ex.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/5/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let mainColor = UIColor(red: 218/255, green: 200/255, blue: 179/255, alpha: 1)
    static let mainLightColor = UIColor(red: 235/255, green: 232/255, blue: 228/255, alpha: 1)
    static let secondaryColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
    static let textDarkColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
    static let textGoldColor = UIColor(red: 173/255, green: 134/255, blue: 100/255, alpha: 1)
    static let blueLink = UIColor(red: 6/255, green: 69/255, blue: 173/255, alpha: 1)
    static let selectionCellBG = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
    
}

extension UIColor {
    
    func image(_ size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { (rendeContext) in
            self.setFill()
            rendeContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: r, green: g, blue: b, alpha: alpha)
            return
        }
        
        r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
