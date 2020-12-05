//
//  ZSCheckoutAddressViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCheckoutAddressViewController: UIViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    
    // MARK: - GUI Variables
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Детали доставки"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mainView: ZSCheckoutAddressView = {
        var view = ZSCheckoutAddressView()
        view.addAddressButtonTappedHandler = { [weak self] in
            let controller = ZSAddAddressViewController()
            let navController = UINavigationController(rootViewController: controller)
            
            self?.present(navController, animated: true, completion: nil)
        }
        
        view.selectedAddressLabelTappedHandler = { [weak self] in
            let controller = ZSAdressViewController(isPresented: true)
            let navController = UINavigationController(rootViewController: controller)
            controller.selectedAddressHandler = { [weak self] address in
                self?.updateAddressWith(address)
            }
            self?.present(navController, animated: true, completion: nil)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .mainColor
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        addSubviews()
        makeConstraints()
        let storage = AddressStorage()
        if storage.addresses.count > 0 {
            updateAddressWith(storage.addresses[0])
        }
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(view.frame.width - 40)
            make.bottom.lessThanOrEqualToSuperview().inset(70)
        }
        continueButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(continueButton)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(mainView)
    }
    
    // MARK: - Actions
    
    @objc private func continueButtonTapped(_ sender: UIButton) {
        guard let parent = parent as? ZSCheckoutViewController else { return }
        parent.moveToNext()
    }
    
    // MARK: - Helpers
    
    private func updateAddressWith(_ address: AddressModel) {
        var string = "Страна: \(address.country)\n"
        string += "Город: \(address.city)\n"
        string += "Область: \(address.district)\n"
        string += "Улица: \(address.street)\n"
        string += "Дом: \(address.house)\n"
        string += "Квартира: \(address.apartment)\n"
        string += "Индекс: \(address.index)\n"
        
        mainView.addressLabel.text = string
    }
    
}
