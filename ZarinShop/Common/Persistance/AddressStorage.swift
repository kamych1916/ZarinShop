//
//  AddressStorage.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 04/12/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct AddressStorage: Codable {
    var addresses: [AddressModel] {
        get {
            guard let addresses: [AddressModel] = try? CodableStorage.shared.fetch(for: "addresses") else { return [] }
            return addresses
        }
        set {
            try? CodableStorage.shared.save(newValue, for: "addresses")
        }
    }
}

struct AddressModel: Codable {
    var country: String
    var city: String
    var district: String
    var street: String
    var house: String
    var apartment: String
    var index: String
}
