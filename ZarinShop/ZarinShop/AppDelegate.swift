//
//  AppDelegate.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupWindow()
        
        return true
    }
    
    private func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return }
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
    }
    
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return self.window!.rootViewController as! RootViewController
    }
}
