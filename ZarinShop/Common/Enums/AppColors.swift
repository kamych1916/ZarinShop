//
//  AppColors.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

enum AppColors {
    
    case mainColor
    case mainLightColor
    case secondaryColor
    case textDarkColor
    case textGoldColor
    case blueLink
    
    func color() -> UIColor {
        switch self {
        case .mainColor:
            return UIColor(red: 218/255, green: 200/255, blue: 179/255, alpha: 1)
        case .mainLightColor:
            return UIColor(red: 235/255, green: 232/255, blue: 228/255, alpha: 1)
        case .secondaryColor:
            return UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
        case .textDarkColor:
            return UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        case .textGoldColor:
            return UIColor(red: 173/255, green: 134/255, blue: 100/255, alpha: 1)
        case .blueLink:
            return UIColor(red: 6/255, green: 69/255, blue: 173/255, alpha: 1)
        }
    }
}
