//
//  UIColor+Ex.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/5/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

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
