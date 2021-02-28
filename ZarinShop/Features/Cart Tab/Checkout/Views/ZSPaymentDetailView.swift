//
//  ZSPaymentDetailView.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 20.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSPaymentDetailView: UIView {
    
    //MARK: - GUI variables
    
    lazy var firstnameField = CustomTextField(placeholder: "Имя")
    lazy var lastnameField = CustomTextField(placeholder: "Фамилия")
    lazy var countryField = CustomTextField(placeholder: "Страна")
    lazy var cityField = CustomTextField(placeholder: "Город")
    lazy var regionField = CustomTextField(placeholder: "Регион/область")
    lazy var streetField = CustomTextField(placeholder: "Улица и дом")
    lazy var codeField = CustomTextField(placeholder: "Почтовый индекс")
    
    lazy var emailField: CustomTextField = {
        var field = CustomTextField(placeholder: "E-mail")
        field.keyboardType = .emailAddress
        return field
    }()
    
    lazy var phoneField: CustomTextField = {
        var field = CustomTextField(placeholder: "Телефон")
        field.keyboardType = .phonePad
        return field
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .mainLightColor
        addSubviews()
        subviews.forEach {
            $0.backgroundColor = .white
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        firstnameField.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        lastnameField.snp.updateConstraints { (make) in
            make.top.equalTo(firstnameField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        emailField.snp.updateConstraints { (make) in
            make.top.equalTo(lastnameField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        phoneField.snp.updateConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        countryField.snp.updateConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        cityField.snp.updateConstraints { (make) in
            make.top.equalTo(countryField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        regionField.snp.updateConstraints { (make) in
            make.top.equalTo(cityField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        streetField.snp.updateConstraints { (make) in
            make.top.equalTo(regionField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
//        houseField.snp.updateConstraints { (make) in
//            make.top.equalTo(streetField.snp.bottom).offset(20)
//            make.left.equalToSuperview().inset(20)
//            make.size.equalTo(CGSize(width: 150, height: 60))
//        }
//        apartmentField.snp.updateConstraints { (make) in
//            make.top.equalTo(streetField.snp.bottom).offset(20)
//            make.left.lessThanOrEqualTo(houseField.snp.right).offset(20)
//            make.right.equalToSuperview().inset(20)
//            make.height.equalTo(60)
//        }
        codeField.snp.updateConstraints { (make) in
            make.top.equalTo(streetField.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        addSubview(firstnameField)
        addSubview(lastnameField)
        addSubview(emailField)
        addSubview(phoneField)
        addSubview(countryField)
        addSubview(cityField)
        addSubview(regionField)
        addSubview(streetField)
        addSubview(codeField)
    }
    
}
