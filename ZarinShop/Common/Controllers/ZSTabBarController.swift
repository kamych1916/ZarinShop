//
//  ZSTabBarController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 11/14/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - GUI variables
    
    private lazy var mainTab: ZSMainViewController = {
        let controller = ZSMainViewController()
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
        viewControllers = tabs.map { UINavigationController(rootViewController: $0)}
        
        delegate = self
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let navigVC = viewController as? UINavigationController,
           (navigVC.viewControllers.first is ZSCartViewController ||
            navigVC.viewControllers.first is ZSFavoritesViewController) &&
            !UserDefaults.standard.isSingin() {
            alertForSignin()
            return false
        } else {
            tabBar.tintColor = .black
            return true
        }
    }
    
    private func alertForSignin() {
        let alert = UIAlertController(
            title: "Ошибка", message: "Чтобы продолжить, нужно автризоваться", preferredStyle: .alert)
        alert.addAction(.init(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(.init(title: "Авторизация", style: .default, handler: { [weak self] (_) in
            let controller = ZSAuthorizationViewController()
            controller.modalPresentationStyle = .fullScreen
            controller.loginHandler = { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            self?.present(controller, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
