//
//  ZSSignupUserModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import Foundation

struct ZSSignupUserModel: Codable {
    
    let id: Int
    let firstname: String
    let lastname: String
    let email: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstname = "first_name"
        case lastname = "last_name"
        case email = "email"
    }
    
}
