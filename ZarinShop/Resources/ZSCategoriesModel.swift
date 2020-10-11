//
//  ZSCategoriesModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSCategoriesModel: Codable {
    let id: String
    let name: String
    let list_of_subtype: [String]
}
