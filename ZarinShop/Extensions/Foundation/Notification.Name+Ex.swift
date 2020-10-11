//
//  NotificationName+Ex.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let favoritesValueChanged = Notification.Name("favoritesValueChanged")
    static let cartValueChanged = Notification.Name("cartValueChanged")
    static let sortButtonTapped = Notification.Name("sortButtonTapped")
    static let filterButtonTapped = Notification.Name("filterButtonTapped")
    static let registationIsSuccessfully = Notification.Name("registationIsSuccessfully")
}
