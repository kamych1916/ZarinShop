//
//  CartModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/29/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import Foundation

struct CartModel: Codable {
    let id: Int
    let id_user: Int
    let items: [CartItemModel]
}

struct CartItemModel: Codable {
    let id: Int
    let name: String
    let size: String
    let kol: Int
    let color: String
    let images: [String]
    let price: Double
    let discount: Double
    let stock: Int
    
    var dictionaryDescription: [String: Any] {
        return [
            "id": id,
            "name": name,
            "size": size,
            "kol": kol,
            "color": color,
            "images": images,
            "price": price,
            "discount": discount,
            "stock": stock
        ]
    }
}
