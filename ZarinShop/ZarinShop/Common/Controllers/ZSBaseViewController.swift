//
//  ZSBaseViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSBaseViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var isNeedMenuBarButton: Bool = false {
        willSet {
            if newValue {
                self.navigationItem.leftBarButtonItem = self.menuBarButton
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    // MARK: - Private Variables
    
    private var favoritesCount: Int = 1 {
        willSet {
            self.favoritesBarButton.setBadge(with: newValue)
        }
    }
    private var cartCount: Int = 1
    
    // MARK: - GUI Variables
    
    private lazy var menuBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "menu"), style: .plain,
            target: self, action: #selector(self.menuBarButtonTapped))
        button.tintColor = AppColors.darkGray.color()
        return button
    }()
    
    private lazy var favoritesBarButton: BadgedButtonItem = {
        var button = BadgedButtonItem(with: UIImage(named: "heart"))
        button.position = .left
        button.badgeTintColor = AppColors.mainColor.color()
        button.badgeSize = .large
        button.badgeAnimation = true
        button.setBadge(with: self.favoritesCount)
        button.tintColor = AppColors.mainLightColor.color()
        return button
    }()
    
    private lazy var cartBarButton: BadgedButtonItem = {
        var button = BadgedButtonItem(with: UIImage(named: "cart"))
        button.position = .left
        button.badgeTintColor = AppColors.mainColor.color()
        button.badgeSize = .large
        button.badgeAnimation = true
        button.setBadge(with: self.cartCount)
        button.tintColor = .red//AppColors.mainLightColor.color()
        return button
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        self.addObservers()
    }
    
    // MARK: - Actions
    
    @objc private func menuBarButtonTapped() {
        self.sideMenuController?.revealMenu()
    }
    
    @objc private func favoriteBarButtonTapped() {
        print("favorite tapped")
    }
    
    @objc private func cartBarButtonTapped() {
        print("cart tapped")
    }
    
    @objc private func favoritesValueChanged(_ notification: Notification) {
        guard let value = notification.userInfo?["favoritesCount"] as? Int else { return }
        self.favoritesCount = value
    }
    
    @objc private func cartValueChanged(_ notification: Notification) {
        self.cartCount += 1
        self.cartBarButton.setBadge(with: self.favoritesCount)
    }
    
    // MARK: - Setters
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItems = [self.cartBarButton, self.favoritesBarButton]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        //barButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.backBarButtonItem?.tintColor = AppColors.darkGray.color()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.favoritesValueChanged),
            name: .favoritesValueChanged, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.cartValueChanged),
            name: .cartValueChanged, object: nil)
    }
    
    // MARK: - Helpers
    
    func pushVC(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popVC(to viewController: UIViewController? = nil) {
        if let viewController = viewController {
            self.navigationController?.popToViewController(viewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToRootVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
