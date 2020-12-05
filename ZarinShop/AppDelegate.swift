//
//  AppDelegate.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setup()
        return true
    }
    
    private func setup() {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return }
        Interface.shared.setup(window: window)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        if !UserDefaults.standard.isSingin() {
            UserDefaults.standard.setLogoutUser()
        }
    }
    
}
