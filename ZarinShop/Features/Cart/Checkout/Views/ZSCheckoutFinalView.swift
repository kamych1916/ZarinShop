//
//  ZSCheckoutFinalView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/25/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCheckoutFinalView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - GUI variables
    
    private lazy var deliveryView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Доставка"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryDescriptionLabel1: UILabel = {
        var label = UILabel()
        label.text = "Доставка на адрес"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryDescriptionLabel2: UILabel = {
        var label = UILabel()
        label.text = "Ташкент, ул. Ленина, дом 2, кв. 60"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Оплата"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentDescriptionLabel1: UILabel = {
        var label = UILabel()
        label.text = "Безналичные (картой)"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentDescriptionLabel2: UILabel = {
        var label = UILabel()
        label.text = "***********1234"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Итого"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalItemsLabel1: UILabel = {
        var label = UILabel()
        label.text = "Всего товаров"
        label.textAlignment = .left
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalItemsLabel2: UILabel = {
        var label = UILabel()
        label.text = "13"
        label.textAlignment = .right
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel1: UILabel = {
        var label = UILabel()
        label.text = "Сумма"
        label.textAlignment = .left
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel2: UILabel = {
        var label = UILabel()
        label.text = "1000 сум"
        label.textAlignment = .right
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.deliveryView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.deliveryTitleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.deliveryDescriptionLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        self.deliveryDescriptionLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryDescriptionLabel1.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        self.paymentView.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.paymentTitleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.paymentDescriptionLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(self.paymentTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        self.paymentDescriptionLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.paymentDescriptionLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        
        self.totalView.snp.updateConstraints { (make) in
            make.top.equalTo(self.paymentView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.totalTitleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.totalItemsLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(self.totalTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        self.totalItemsLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.totalTitleLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(20)
        }
        self.totalPriceLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(self.totalItemsLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.totalPriceLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.totalItemsLabel2.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .mainColor
    }
    
    private func addSubviews() {
        self.addSubview(self.deliveryView)
        self.deliveryView.addSubview(self.self.deliveryTitleLabel)
        self.deliveryView.addSubview(self.self.deliveryDescriptionLabel1)
        self.deliveryView.addSubview(self.self.deliveryDescriptionLabel2)
        
        self.addSubview(self.paymentView)
        self.paymentView.addSubview(self.self.paymentTitleLabel)
        self.paymentView.addSubview(self.self.paymentDescriptionLabel1)
        self.paymentView.addSubview(self.self.paymentDescriptionLabel2)
        
        self.addSubview(self.totalView)
        self.totalView.addSubview(self.self.totalTitleLabel)
        self.totalView.addSubview(self.self.totalItemsLabel1)
        self.totalView.addSubview(self.self.totalItemsLabel2)
        self.totalView.addSubview(self.self.totalPriceLabel1)
        self.totalView.addSubview(self.self.totalPriceLabel2)
    }
    
    //MARK: - Actions

    
}

