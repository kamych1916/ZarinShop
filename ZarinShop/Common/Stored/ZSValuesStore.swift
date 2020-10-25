//
//  ZSValuesStore.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/15/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

typealias Values = ZSValuesStore

class ZSValuesStore {
    
    static let shared = ZSValuesStore()
    
    // MARK: - Public variables
    
    var cartCount: Int = 1
    var favoritesCount: Int = 1
    
    // MARK: - Initialization
    
    private init() {}
    
}
