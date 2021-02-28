//
//  ZSProductModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

struct ZSProductModel: Codable {
    let id: String
    let name: String
    let description: String
    let size_kol: [ZSSizeModel]
    let color: String
    let images: [String]
    let price: Double
    let discount: Double
    let hit_sales: Bool
    let special_offer: Bool
    let categories: [String]
    let link_color: [ZSLinkColorModel]
    var favorites: Bool
    let categories_value: [String]?
    let name_images: [String]?
}


struct ZSFavoritesResponse: Codable {
    
}
