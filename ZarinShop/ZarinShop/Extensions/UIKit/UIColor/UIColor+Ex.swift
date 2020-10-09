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
}
