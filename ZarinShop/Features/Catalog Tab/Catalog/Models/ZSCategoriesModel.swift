//
//  ZSCategoriesModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 28/11/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import Foundation

struct ZSCategoriesModel: Codable {
    let id: String
    let name: String
    let kol: Int
    let subcategories: [ZSSubcategoriesModel]
}
