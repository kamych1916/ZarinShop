//
//  UserDefaults+Ex.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setSinginUser(user: ZSSigninUserModel) {
        set(true, forKey: "isSingin")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            set(encoded, forKey: "signinUserModel")
        }
        synchronize()
    }
    
    func setLogutUser() {
        set(false, forKey: "isSingin")
        removeObject(forKey: "signinUserModel")
        synchronize()
    }

    func isSingin() -> Bool {
        synchronize()
        return bool(forKey: "isSingin")
    }
    
    func getUser() -> ZSSigninUserModel? {
        if let savedUser = object(forKey: "signinUserModel") as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(ZSSigninUserModel.self, from: savedUser) {
                return user
            }
        }
        return nil
    }
    
    func isNeedNotifications() -> Bool {
        synchronize()
        return bool(forKey: "isNeedNotifications")
    }
    
}
