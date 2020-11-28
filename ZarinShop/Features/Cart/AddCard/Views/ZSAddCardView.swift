//
//  ZSAddCardView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/18/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAddCardView: UIView {
    
    //MARK: - GUI variables
    
    private lazy var cardView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cartCVCView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cartCVCLable: UILabel = {
        var label = UILabel()
        label.text = "123"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartNumberLable: UILabel = {
        var label = UILabel()
        label.text = "***********1234"
        label.textColor = .textGoldColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartNameLable: UILabel = {
        var label = UILabel()
        label.text = "NAME SURNAME"
        label.textColor = .textGoldColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartDateLable: UILabel = {
        var label = UILabel()
        label.text = "09/22"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartCVCField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "CVC код"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartNumberField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Номер карты"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartNameField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Имя и фамилия"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartDateYearField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Год"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var cartDateMonthField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = .white
        field.textColor = .textDarkColor
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Месяц"
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
        self.cardView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        self.cartCVCView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.cartCVCLable.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
        self.cartNumberLable.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.cartCVCView.snp.centerY)
        }
        self.cartNameLable.snp.updateConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.cartDateLable.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.cartNameLable.snp.centerY)
        }
        
        self.cartNumberField.snp.updateConstraints { (make) in
            make.top.equalTo(self.cardView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cartNameField.snp.updateConstraints { (make) in
            make.top.equalTo(self.cartNumberField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cartCVCField.snp.updateConstraints { (make) in
            make.top.equalTo(self.cartNameField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        self.cartDateYearField.snp.updateConstraints { (make) in
            make.top.equalTo(self.cartCVCField.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 150, height: 60))
        }
        self.cartDateMonthField.snp.updateConstraints { (make) in
            make.top.equalTo(self.cartCVCField.snp.bottom).offset(20)
            make.left.equalTo(self.cartDateYearField.snp.right).offset(20)
            make.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.cardView)
        self.cardView.addSubview(self.cartCVCView)
        self.cartCVCView.addSubview(self.cartCVCLable)
        self.cardView.addSubview(self.cartNameLable)
        self.cardView.addSubview(self.cartNumberLable)
        self.cardView.addSubview(self.cartDateLable)
        
        self.addSubview(self.cartNumberField)
        self.addSubview(self.cartNameField)
        self.addSubview(self.cartCVCField)
        self.addSubview(self.cartDateYearField)
        self.addSubview(self.cartDateMonthField)
    }
    
}
