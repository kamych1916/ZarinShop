//
//  ZSNetworkError.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ZSErrorModel: Codable {
    var detail: String
}

enum ZSNetworkError: Error, Equatable {
    static func == (lhs: ZSNetworkError, rhs: ZSNetworkError) -> Bool {
        if lhs.getDescription() == rhs.getDescription() {
            return true
        }
        return false
    }
    
    
    case badURL(Error)
    case parsing
    case unauthorized
    case unowned(String)
    
    func getDescription() -> String {
        switch self {
        case .badURL(let error):
            return error.localizedDescription
        case .parsing:
            return "Parsing error"
        case .unauthorized:
            return "Не авторизован"
        case .unowned(let msg):
            return msg
        }
    }
}
