//
//  AddressStorage.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 04/12/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
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
    
    var fullInfo: String {
        [country, "г. " + city, district, "ул. " + street, "кв. " + house].joined(separator: ", ")
    }
}
