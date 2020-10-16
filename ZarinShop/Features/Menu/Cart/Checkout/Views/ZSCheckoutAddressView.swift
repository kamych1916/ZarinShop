//
//  ZSCheckoutAddressView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/16/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCheckoutAddressView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
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
    
    private lazy var deliveryTypeDropButton: UIButton = {
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
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = AppColors.mainColor.color()
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.deliveryTypeView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.deliveryTypeLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.deliveryTypeLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryTypeLabel1.snp.bottom)
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.deliveryTypeDropButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        self.addressView.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryTypeView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.addressLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.addressAddNewButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.addressLabel.snp.centerY)
            make.size.equalTo(48)
        }
        self.addressTextView.snp.updateConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.deliveryTypeView)
        self.addSubview(self.addressView)
        self.deliveryTypeView.addSubview(self.deliveryTypeLabel1)
        self.deliveryTypeView.addSubview(self.deliveryTypeLabel2)
        self.deliveryTypeView.addSubview(self.deliveryTypeDropButton)
        self.addressView.addSubview(self.addressLabel)
        self.addressView.addSubview(self.addressAddNewButton)
        self.addressView.addSubview(self.addressTextView)
    }
    
}
