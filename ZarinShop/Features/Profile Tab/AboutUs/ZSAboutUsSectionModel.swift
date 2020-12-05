//
//  ZSAboutUsSectionModel.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 05/12/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
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
