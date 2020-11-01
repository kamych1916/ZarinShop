//
//  ZSURLPath.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

typealias Path = ZSURLPath

struct ZSURLPath {
    
    //MARK: - Auth
    
    static let signin = "signin"    ///login
    static let signup = "signup"    ///registration
    
    //MARK: - Get
    
    static let categories = "categories"
    static let checkCode = "checkcode_activ/"
    static let resetPassword = "reset_password"
    static let productsByID = "items_cat/"
    static let getCartList = "cart/shopping_cart"
    
    //MARK: - Post
    
    static let changePassword = "change_password"
    static let addToCart = "cart/addProduct" 
   
    //MARK: - Delete
    
    static let logout = "logout"
    
}
