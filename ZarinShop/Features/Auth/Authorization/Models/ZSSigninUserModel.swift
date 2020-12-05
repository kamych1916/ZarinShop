//
//  ZSSigninUserModel.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSSigninUserModel: Codable {
    
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstname = "first_name"
        case lastname = "last_name"
        case email = "email"
        case token = "session_token"
    }
    
}

struct ZSUser: Codable {
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    
}
