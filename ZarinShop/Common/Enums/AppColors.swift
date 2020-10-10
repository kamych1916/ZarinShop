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
    case textDarkColor
    case textGoldColor
    
    case darkGray
    case grayTextColor
    case lightGrayColor
    case lightPinkColor
    case lightPurple
    case mediumGrayTextColor
    case pinkColor
    case purpuleColor
    case backgroundColor
    
    func color() -> UIColor {
        switch self {
            
        case .mainColor:
            return UIColor(red: 218/255, green: 200/255, blue: 179/255, alpha: 1)
        case .mainLightColor:
            return UIColor(red: 235/255, green: 232/255, blue: 228/255, alpha: 1)
        case .textDarkColor:
            return UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        case .textGoldColor:
            return UIColor(red: 173/255, green: 134/255, blue: 100/255, alpha: 1)
            
            
        case .darkGray:
            return UIColor(red: 25/255, green: 54/255, blue: 95/255, alpha: 1)
        case .grayTextColor:
            return UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        case .lightGrayColor:
            return UIColor(red: 235/255, green: 242/255, blue: 254/255, alpha: 1)
        case .lightPinkColor:
            return UIColor(red: 235/255, green: 70/255, blue: 135/255, alpha: 1)
        case .lightPurple:
            return UIColor(red: 150/255, green: 94/255, blue: 255/255, alpha: 1)
        case .mediumGrayTextColor:
            return UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        case .pinkColor:
            return UIColor(red: 235/255, green: 70/255, blue: 135/255, alpha: 1)
        case .purpuleColor:
            return UIColor(red: 150/255, green: 94/255, blue: 255/255, alpha: 1)
        case .backgroundColor:
            return UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
        }
    }
}
