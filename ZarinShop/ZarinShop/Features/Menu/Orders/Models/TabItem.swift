//
//  tt'.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/9/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

struct TabItem {
    let title: String
    let tintColor: UIColor
    let normalImage: UIImage
    let highlightedImage: UIImage
}

class TabItemsProvider {
    
    static let items = {
        return [
            TabItem(
                title: "Shipping",
                tintColor: AppColors.mainColor.color(),
                normalImage: UIImage(named: "cart")!,
                highlightedImage: UIImage(named: "home")!
            ),
            TabItem(
                title: "Payment",
                tintColor: AppColors.mainColor.color(),
                normalImage: UIImage(named: "location")!,
                highlightedImage: UIImage(named: "phone")!
            ),
            TabItem(
                title: "Order",
                tintColor: AppColors.mainColor.color(),
                normalImage: UIImage(named: "profile")!,
                highlightedImage: UIImage(named: "logout")!
            )
        ]
    }()
    
}
