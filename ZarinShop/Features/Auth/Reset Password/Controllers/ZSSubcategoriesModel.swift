//
//  ZSSubcategoriesModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSSubcategoriesModel: Codable {
    let id: String
    let name: String
    let subcategories: [ZSSubcategoriesModel]
}
