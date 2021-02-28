//
//  ZSProductDetailTitleView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/15/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSProductDetailTitleView: UIView {
    
    //MARK: - GUI variables
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var discountLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemRed
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var discountLineView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear//.systemRed
        return view
    }()
    
    lazy var stepperView: ZSStepperView = {
        var view = ZSStepperView()
        view.value = 1
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 20
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
    }
    
    func initView(name: String, price: String, discaunt: String) {
        
        nameLabel.text = name
        priceLabel.text = price
        discountLabel.text = "-" + discaunt
        
        setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        nameLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.updateConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        discountLabel.snp.updateConstraints { (make) in
            make.top.equalTo(priceLabel)
            make.left.equalTo(priceLabel.snp.right).offset(10)
        }
        
        discountLineView.snp.updateConstraints { (make) in
            make.left.right.centerY.equalTo(discountLabel)
            make.height.equalTo(0.7)
        }
        
        stepperView.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(8)
            make.centerY.equalTo(priceLabel)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(discountLabel)
        addSubview(discountLineView)
        addSubview(stepperView)
    }
    
}
