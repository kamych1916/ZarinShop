//
//  ZSTabBarController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 11/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - GUI variables
    
    private lazy var mainTab: UIViewController = {
        let controller = UIViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(named: "home"), tag: 0)
        return controller
    }()
    
    private lazy var searchTab: ZSCatalogViewController = {
        let controller = ZSCatalogViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(named: "search"), tag: 0)
        return controller
    }()
    
    private lazy var cartTab: ZSCartViewController = {
        let controller = ZSCartViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(named: "cart"), tag: 0)
        return controller
    }()
    
    private lazy var favoriteTab: ZSFavoritesViewController = {
        let controller = ZSFavoritesViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Избранные",
            image: UIImage(named: "heart"), tag: 0)
        return controller
    }()

    private lazy var profile: ZSProfileViewController = {
        let controller = ZSProfileViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(named: "profile"), tag: 1)
        return controller
    }()

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabs = [self.mainTab, self.searchTab, self.cartTab, self.favoriteTab, self.profile]
        self.viewControllers = tabs.map { UINavigationController(rootViewController: $0)}
        self.tabBarStyle()
    }

    // MARK: - Setters
    
    private func tabBarStyle() {
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
    }
    
}
