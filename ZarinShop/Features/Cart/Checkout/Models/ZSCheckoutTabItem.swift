//
//  tt'.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/9/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

struct ZSCheckoutTabItem {
    
    let title: String
    let tintColor: UIColor
    let image: UIImage
    var normalImage: UIImage {
        return self.image.with(color: AppColors.mainColor.color())
    }
    var highlightedImage: UIImage {
        return self.image.with(color: .white)
    }
    
}

class ZSCheckoutTabItemsProvider {
    
    static let items = {
        return [
            ZSCheckoutTabItem(
                title: "Доставка",
                tintColor: AppColors.mainColor.color(),
                image: UIImage(named: "shippingTab")!
            ),
            ZSCheckoutTabItem(
                title: "Оплата",
                tintColor: AppColors.mainColor.color(),
                image: UIImage(named: "paymentTab")!
            ),
            ZSCheckoutTabItem(
                title: "Финиш",
                tintColor: AppColors.mainColor.color(),
                image: UIImage(named: "orderTab")!
            )
        ]
    }()
    
}
