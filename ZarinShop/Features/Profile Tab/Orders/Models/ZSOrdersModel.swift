//
//  ZSOrdersModel.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 28.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSOrderItemModel: Codable {
    let id: String
    let date: String
    let items: [CartItemModel]
    let user_info: String
    let subtotal: Int
    let state: String
    let shipping_type: String
    let shipping_adress: String
}
