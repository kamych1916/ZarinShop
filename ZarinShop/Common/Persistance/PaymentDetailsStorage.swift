//
//  PaymentDetailsStorage.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 20.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import Foundation


struct PaymentDetailsStorage: Codable {
    var paymentDetails: PaymentDetailsModel? {
        get {
            guard let paymentDetails: PaymentDetailsModel = try? CodableStorage.shared.fetch(for: "paymentDetails") else { return nil }
            return paymentDetails
        }
        set {
            try? CodableStorage.shared.save(newValue, for: "paymentDetails")
        }
    }
}

struct PaymentDetailsModel: Codable {
    var firstName: String
    var lastName: String
    var phone: String
    var email: String
    var address: String
    var city: String
    var state: String
    var pincode: String
    
    var dictionaryDescription: [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "email": email,
            "address": address,
            "city": city,
            "state": state,
            "pincode": pincode
        ]
    }
}
