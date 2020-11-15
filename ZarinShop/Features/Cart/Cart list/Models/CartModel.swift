//
//  CartModel.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/29/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct CartModel: Codable {
    let id: Int
    let id_user: Int
    let items: [CartItemModel]
}

struct CartItemModel: Codable {
    let id: Int
    let size: String
    let kol: Int
    let image: [String]
    let price: Float
    let discount: Float
}
