//
//  ZSURLPath.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

typealias URLPath = ZSURLPath

enum ZSURLPath: String {
    
    //MARK: - Get

    case signin = "signin"
    case signup = "signup"
    case isLogin = "is_login"
    case categories = "categories"
    case checkCode = "checkcode_activ/"
    case resetPassword = "reset_password"
    case productsByID = "items_cat/"
    case getCartList = "cart/shopping_cart"
    case searchProducts = "search"
    case hitSales = "hit_sales"
    case specialOffer = "special_offer"
    
    //MARK: - Post
    
    case changePassword = "change_password"
    case addToCart = "cart/addProduct"
   
    //MARK: - Delete
    
    case logout = "logout"
    case delproduct = "cart/delproduct"
    
}
