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
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mainView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = AppColors.mainColor.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryTypeView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryTypeLabel1: UILabel = {
        var label = UILabel()
        label.text = "Способ доставки"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryTypeLabel2: UILabel = {
        var label = UILabel()
        label.text = "На дом"
        label.textColor = AppColors.textDarkColor.color().withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryTypeDropИгеещт: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "dropdown")
        image = image?.imageWithColor(color: AppColors.textDarkColor.color())
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addressView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.text = "Адрес доставки"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressAddNewButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "plus")
        image = image?.imageWithColor(color: AppColors.textDarkColor.color())
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addressTextView: UITextView = {
        var textView = UITextView()
        textView.text =
        """
        Город: Ташкент
        Область: Тестовая область
        Улица: Тестовая улица
        Дом: 16
        Квартира: 79
        """
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.textColor = AppColors.textDarkColor.color().withAlphaComponent(0.7)
        textView.font = .systemFont(ofSize: 17, weight: .medium)
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("a")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground
        self.addSubviews()
        self.makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(self.view.frame.width - 40)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        self.deliveryTypeView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.deliveryTypeLabel1.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.deliveryTypeLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryTypeLabel1.snp.bottom)
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.deliveryTypeDropИгеещт.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        self.addressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryTypeView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.addressLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.addressAddNewButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.addressLabel.snp.centerY)
            make.size.equalTo(48)
        }
        self.addressTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.mainView)
        self.mainView.addSubview(self.deliveryTypeView)
        self.deliveryTypeView.addSubview(self.deliveryTypeLabel1)
        self.deliveryTypeView.addSubview(self.deliveryTypeLabel2)
        self.deliveryTypeView.addSubview(self.deliveryTypeDropИгеещт)
        self.mainView.addSubview(self.addressView)
        self.addressView.addSubview(self.addressLabel)
        self.addressView.addSubview(self.addressAddNewButton)
        self.addressView.addSubview(self.addressTextView)
    }
    
    // MARK: - Helpers
    
}

