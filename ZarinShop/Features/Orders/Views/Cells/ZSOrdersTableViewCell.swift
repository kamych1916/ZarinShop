//
//  ZSOrdersTableViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/25/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

import UIKit

class ZSOrdersTableViewCell: UITableViewCell {
    
    static let identifier = "ZSOrdersTableViewCell"
    
    // MARK: - GUI Variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.mainColor.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var orderNumberLabel1: UILabel = {
        var label = UILabel()
        label.text = "Номер заказа"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var orderNumberLabel2: UILabel = {
        var label = UILabel()
        label.text = "315412"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var orderDateLabel1: UILabel = {
        var label = UILabel()
        label.text = "Дата заказа"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var orderDateLabel2: UILabel = {
        var label = UILabel()
        label.text = "23/11/2020"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalItemsLabel1: UILabel = {
        var label = UILabel()
        label.text = "Всего товаров"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalItemsLabel2: UILabel = {
        var label = UILabel()
        label.text = "17"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel1: UILabel = {
        var label = UILabel()
        label.text = "Сумма"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalPriceLabel2: UILabel = {
        var label = UILabel()
        label.text = "13123 сум"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell() {
        
        self.setNeedsUpdateConstraints()
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        self.orderNumberLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.orderNumberLabel2.snp.updateConstraints { (make) in
            make.top.right.equalToSuperview().inset(20)
        }
        
        self.orderDateLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(self.orderNumberLabel1.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        self.orderDateLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.orderNumberLabel2.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(20)
        }
        
        self.totalItemsLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(self.orderDateLabel1.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        self.totalItemsLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.orderDateLabel2.snp.bottom).offset(10)
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
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.orderNumberLabel1)
        self.containerView.addSubview(self.orderNumberLabel2)
        
        self.containerView.addSubview(self.orderDateLabel1)
        self.containerView.addSubview(self.orderDateLabel2)
        
        self.containerView.addSubview(self.totalItemsLabel1)
        self.containerView.addSubview(self.totalItemsLabel2)
        
        self.containerView.addSubview(self.totalPriceLabel1)
        self.containerView.addSubview(self.totalPriceLabel2)
    }
    
}
