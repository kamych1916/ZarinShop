//
//  ZSCategoriesModel.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 28/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSCategoriesModel: Codable {
    let id: String
    let name: String
    let kol: Int
    let subcategories: [ZSSubcategoriesModel]
}
