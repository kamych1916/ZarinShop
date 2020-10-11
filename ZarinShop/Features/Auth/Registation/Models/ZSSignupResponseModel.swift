//
//  ZSSignupResponseModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSSignupResponseModel: Codable {
    let status_code: Int
    let detail: String
    let headers: String?
}
