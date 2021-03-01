//
//  ZSOrderState.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 28.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import Foundation

enum ZSOrderState: String, CaseIterable {
    case completed
    case awaiting
    case canceled
    
    var localized: String {
        switch self {
        case .awaiting: return "В ожидании"
        case .completed: return "Доставлено"
        case .canceled: return "Отменено"
        }
    }
}
