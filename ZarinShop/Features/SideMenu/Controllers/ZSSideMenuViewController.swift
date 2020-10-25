//
//  ZSSideMenuViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SideMenuSwift
import SnapKit

class ZSSideMenuViewController: UIViewController {
    
    // MARK: - GUI Variables
    
    private lazy var contantView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var companyNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Zapin Shop"
        label.textColor = AppColors.mainColor.color()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Войти в профиль", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.signinButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var userView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var userNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.text = "Some user name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userEmailLabel: UILabel = {
        var label = UILabel()
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.text = "user@mail.some"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var menuView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = AppColors.mainColor.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemsStackView: UIStackView = {
        var view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainItem: ZSSideMenuItemView = {
        var view = ZSSideMenuItemView()
        view.initView(image: UIImage(named: "home"), title: "Главная")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.mainItemTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var profileItem: ZSSideMenuItemView = {
        var view = ZSSideMenuItemView()
        view.initView(image: UIImage(named: "profile"), title: "Личный кабинет")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileItemTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var orderItem: ZSSideMenuItemView = {
        var view = ZSSideMenuItemView()
        view.initView(image: UIImage(named: "order"), title: "Мои заказы")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.orderItemTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var cartItem: ZSSideMenuItemView = {
        var view = ZSSideMenuItemView()
        view.initView(image: UIImage(named: "cart"), title: "Корзина")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cartItemTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var footerView: ZSSideMenuFooterView = {
        var view = ZSSideMenuFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
        self.setupSideBar()
        self.setupPreferences()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViewWithSingin()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.contantView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.top.right.bottom.equalToSuperview()
        }
        self.companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.left.right.equalToSuperview().inset(30)
        }
        self.signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.companyNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        self.userView.snp.makeConstraints { (make) in
            make.top.equalTo(self.companyNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
        }
        self.userNameLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.userEmailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userNameLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        self.menuView.snp.makeConstraints { (make) in
            make.top.equalTo(self.userView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.itemsStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
        self.footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func mainItemTapped() {
        self.setContentViewController(with: "mainSide")
    }
    
    @objc private func cartItemTapped() {
        self.setContentViewController(with: "cartSide")
    }
    
    @objc private func orderItemTapped() {
        self.setContentViewController(with: "ordersSide")
    }
    
    @objc private func profileItemTapped() {
        self.setContentViewController(with: "profileSide")
    }
    
    @objc private func signinButtonTapped(_ sener: UIButton) {
        let authVC = ZSAuthorizationViewController()
        authVC.modalPresentationStyle = .fullScreen
        authVC.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        authVC.loginHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.setupViewWithSingin()
        }
        self.present(authVC, animated: true, completion: nil)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.contantView)
        
        self.contantView.addSubview(self.companyNameLabel)
        self.contantView.addSubview(self.signInButton)
        
        self.contantView.addSubview(self.userView)
        self.userView.addSubview(self.userNameLabel)
        self.userView.addSubview(self.userEmailLabel)
        
        self.contantView.addSubview(self.menuView)
        self.menuView.addSubview(self.itemsStackView)
        self.itemsStackView.addArrangedSubview(self.mainItem)
        self.itemsStackView.addArrangedSubview(self.profileItem)
        self.itemsStackView.addArrangedSubview(self.orderItem)
        self.itemsStackView.addArrangedSubview(self.cartItem)
        
        self.contantView.addSubview(self.footerView)
    }
    
    private func setupSideBar() {
        let mainVC = UINavigationController(rootViewController: ZSMainViewController())
        let cartVC = UINavigationController(rootViewController: ZSCartViewController())
        let ordersVC = UINavigationController(rootViewController: ZSOrdersViewController())
        let profileVC = UINavigationController(rootViewController: ZSProfileViewController())
        
        guard let sideVC = self.sideMenuController else { return }
        sideVC.cache(viewController: mainVC, with: "mainSide")
        sideVC.cache(viewController: cartVC, with: "cartSide")
        sideVC.cache(viewController: ordersVC, with: "ordersSide")
        sideVC.cache(viewController: profileVC, with: "profileSide")
        
        self.sideMenuController?.delegate = self
    }
    
    private func setupPreferences() {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width - 50
    }
    
    private func setupViewWithSingin() {
        if UserDefaults.standard.isSingin() {
            self.signInButton.isHidden = true
            self.signInButton.isEnabled = false
            self.userView.isHidden = false
            if let user = UserDefaults.standard.getUser() {
                self.userNameLabel.text = user.firstname + " " + user.lastname
                self.userEmailLabel.text = user.email
            }
        } else {
            self.signInButton.isHidden = false
            self.signInButton.isEnabled = true
            self.userView.isHidden = true
        }
    }

    // MARK: - Helpers
    
    private func setContentViewController(with id: String) {
        self.sideMenuController?.setContentViewController(with: id, animated: true, completion: nil)
        self.sideMenuController?.hideMenu()
    }
    
}

// MARK: - SideMenuControllerDelegate

extension ZSSideMenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController, animationControllerFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .curveEaseIn, duration: 0.6)
    }
    
}
