//
//  ZSAddAddressView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/18/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAddAddressView: UIView {
    
    //MARK: - GUI variables

    private lazy var countryField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Страна"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cityField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Город"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var regionField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Регион/область"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var streetField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Улица"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var houseField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Дом"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var apartmentField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Квартира"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var codeField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Почтовый индекс"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .mainLightColor
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.countryField.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cityField.snp.updateConstraints { (make) in
            make.top.equalTo(self.countryField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.regionField.snp.updateConstraints { (make) in
            make.top.equalTo(self.cityField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.streetField.snp.updateConstraints { (make) in
            make.top.equalTo(self.regionField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.houseField.snp.updateConstraints { (make) in
            make.top.equalTo(self.streetField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 150, height: 60))
        }
        self.apartmentField.snp.updateConstraints { (make) in
            make.top.equalTo(self.streetField.snp.bottom).offset(20)
            make.left.lessThanOrEqualTo(self.houseField.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.codeField.snp.updateConstraints { (make) in
            make.top.equalTo(self.houseField.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.countryField)
        self.addSubview(self.cityField)
        self.addSubview(self.regionField)
        self.addSubview(self.streetField)
        self.addSubview(self.houseField)
        self.addSubview(self.apartmentField)
        self.addSubview(self.codeField)
    }
    
}
