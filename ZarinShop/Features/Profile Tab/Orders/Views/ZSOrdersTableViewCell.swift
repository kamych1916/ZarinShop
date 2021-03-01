//
//  ZSOrdersTableViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/25/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
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
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var orderNumberLabel2: UILabel = {
        var label = UILabel()
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var orderDateLabel1: UILabel = {
        var label = UILabel()
        label.text = "Дата заказа"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var orderDateLabel2: UILabel = {
        var label = UILabel()
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalItemsLabel1: UILabel = {
        var label = UILabel()
        label.text = "Всего товаров"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalItemsLabel2: UILabel = {
        var label = UILabel()
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel1: UILabel = {
        var label = UILabel()
        label.text = "Сумма"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalPriceLabel2: UILabel = {
        var label = UILabel()
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell(with model: ZSOrderItemModel) {
        orderNumberLabel2.text = model.id
        orderDateLabel2.text = model.date
        totalItemsLabel2.text = "\(model.items.count)"
        totalPriceLabel2.text = "\(model.subtotal) сум"
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        orderNumberLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        orderNumberLabel2.snp.updateConstraints { (make) in
            make.top.right.equalToSuperview().inset(20)
        }
        
        orderDateLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(orderNumberLabel1.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        orderDateLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(orderNumberLabel2.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(20)
        }
        
        totalItemsLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(orderDateLabel1.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        totalItemsLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(orderDateLabel2.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(20)
        }
        
        totalPriceLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(totalItemsLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        totalPriceLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(totalItemsLabel2.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview().inset(20)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(orderNumberLabel1)
        containerView.addSubview(orderNumberLabel2)
        
        containerView.addSubview(orderDateLabel1)
        containerView.addSubview(orderDateLabel2)
        
        containerView.addSubview(totalItemsLabel1)
        containerView.addSubview(totalItemsLabel2)
        
        containerView.addSubview(totalPriceLabel1)
        containerView.addSubview(totalPriceLabel2)
    }
    
}
