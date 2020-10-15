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
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    // MARK: - GUI Variables
    
    private lazy var menuBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "menu"), style: .plain,
            target: self, action: #selector(self.menuBarButtonTapped))
        button.tintColor = AppColors.mainColor.color()
        return button
    }()
    
    private lazy var favoritesBarButton: BadgedButtonItem = {
        var button = BadgedButtonItem(with: UIImage(named: "heart"))
        button.tapAction = { [weak self] in
            self?.favoriteBarButtonTapped()
        }
        button.position = .left
        button.badgeTintColor = AppColors.mainColor.color()
        button.badgeSize = .large
        button.badgeAnimation = true
        button.setBadge(with: Values.shared.favoritesCount)
        button.tintColor = AppColors.mainLightColor.color()
        return button
    }()
    
    private lazy var cartBarButton: BadgedButtonItem = {
        var button = BadgedButtonItem(with: UIImage(named: "cart"))
        button.tapAction = { [weak self] in
            self?.cartBarButtonTapped()
        }
        button.position = .left
        button.badgeTintColor = AppColors.mainColor.color()
        button.badgeSize = .large
        button.badgeAnimation = true
        button.setBadge(with: Values.shared.cartCount)
        button.tintColor = .red//AppColors.mainLightColor.color()
        return button
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeObservers()
    }
    
    // MARK: - Actions
    
    @objc private func menuBarButtonTapped() {
        self.sideMenuController?.revealMenu()
    }
    
    private func favoriteBarButtonTapped() {
        print("favorite tapped")
    }
    
    private func cartBarButtonTapped() {
        print("cart tapped")
    }
    
    @objc private func favoritesValueChanged(_ notification: Notification) {
        Values.shared.favoritesCount += 1
        self.favoritesBarButton.setBadge(with: Values.shared.favoritesCount)
    }
    
    @objc private func cartValueChanged(_ notification: Notification) {
        Values.shared.cartCount += 1
        self.cartBarButton.setBadge(with: Values.shared.cartCount)
    }
    
    // MARK: - Setters
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItems = [self.cartBarButton, self.favoritesBarButton]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        //barButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.backBarButtonItem?.tintColor = AppColors.mainColor.color()
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
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .favoritesValueChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .cartValueChanged, object: nil)
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
