//
//  tt'.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/9/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

struct ZSCheckoutTabItem {
    
    let title: String
    let tintColor: UIColor
    let image: UIImage
    var normalImage: UIImage {
        return self.image.with(color: .mainColor)
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
                tintColor: .mainColor,
                image: UIImage(named: "shippingTab")!
            ),
            ZSCheckoutTabItem(
                title: "Оплата",
                tintColor: .mainColor,
                image: UIImage(named: "paymentTab")!
            ),
            ZSCheckoutTabItem(
                title: "Финиш",
                tintColor: .mainColor,
                image: UIImage(named: "orderTab")!
            )
        ]
    }()
    
}
