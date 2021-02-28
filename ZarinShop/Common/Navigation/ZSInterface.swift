//
//  ZSInterface.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 11/14/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

typealias Interface = ZSInterface

class ZSInterface {
    
    // MARK: - Public variables
    
    static let shared = ZSInterface()
    weak var window: UIWindow?

    // MARK: - GUI variables
    
    lazy var tabBarController = TabBarController()

    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Setters
    
    func setup(window: UIWindow) {
        window.rootViewController = self.tabBarController
        window.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        self.window = window
    }

    // MARK: - Helpers
    
    func pushVC(vc: UIViewController) {
        (self.tabBarController.selectedViewController as? UINavigationController)?
            .pushViewController(vc, animated: true)
    }

    func popVC(to vc: UIViewController? = nil) {
        if let vc = vc {
            (self.tabBarController.selectedViewController as? UINavigationController)?
                .popToViewController(vc, animated: true)
        } else {
            (self.tabBarController.selectedViewController as? UINavigationController)?
                .popViewController(animated: true)
        }
    }
    
}
