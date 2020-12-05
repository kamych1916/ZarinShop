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

    lazy var countryField: UITextField = {
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
    
    lazy var cityField: UITextField = {
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
    
    lazy var regionField: UITextField = {
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
    
    lazy var streetField: UITextField = {
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
    
    lazy var houseField: UITextField = {
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
    
    lazy var apartmentField: UITextField = {
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
    
    lazy var codeField: UITextField = {
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
        
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .mainLightColor
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        countryField.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
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
        houseField.snp.updateConstraints { (make) in
            make.top.equalTo(streetField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 150, height: 60))
        }
        apartmentField.snp.updateConstraints { (make) in
            make.top.equalTo(streetField.snp.bottom).offset(20)
            make.left.lessThanOrEqualTo(houseField.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        codeField.snp.updateConstraints { (make) in
            make.top.equalTo(houseField.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        addSubview(countryField)
        addSubview(cityField)
        addSubview(regionField)
        addSubview(streetField)
        addSubview(houseField)
        addSubview(apartmentField)
        addSubview(codeField)
    }
    
}
