//
//  FavoritesStorage.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 28.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import Foundation


struct FavoritesStorage: Codable {
    var favorites: [FavoritesModel] {
        get {
            guard let fovorites: [FavoritesModel] = try? CodableStorage.shared.fetch(for: "Favorites") else { return [] }
            return fovorites
        }
        set {
            try? CodableStorage.shared.save(newValue, for: "Favorites")
        }
    }
}

struct FavoritesModel: Codable {
    var id: String
}
