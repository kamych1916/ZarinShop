//
//  ZSAboutUsSectionModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 05/12/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

struct ZSAboutUsSectionModel {
    let title: String
    let items: [ZSAboutUsCellModel]
}

struct ZSAboutUsCellModel {
    let name: String
    let image: UIImage?
}
