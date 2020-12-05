//
//  UserDefaults+Ex.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation
import KeychainAccess

extension UserDefaults {
    
    func setSinginUser(_ model: ZSSigninUserModel) {
        ///Сохрание токена в Keychaine
        ZSNetwork.keychein["service_token"] = model.token
        
        let user = ZSUser(
            id: model.id, firstname: model.firstname,
            lastname: model.lastname, email: model.email)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            set(encoded, forKey: "signinUserModel")
            set(true, forKey: "isSingin")
        }
        synchronize()
    }
    
    func setLogoutUser() {
        ZSNetwork.keychein["service_token"] = nil
        set(false, forKey: "isSingin")
        removeObject(forKey: "signinUserModel")
        synchronize()
    }

    func isSingin() -> Bool {
        synchronize()
        return bool(forKey: "isSingin")
    }
    
    func getUser() -> ZSUser? {
        if let savedUser = object(forKey: "signinUserModel") as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(ZSUser.self, from: savedUser) {
                return user
            }
        }
        return nil
    }
    
}
