//
//  ZSProductDetailTitleView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/15/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductDetailTitleView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initView(name: String, price: String) {
        
        self.nameLabel.text = name
        self.priceLabel.text = price
        
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.nameLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        self.priceLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.priceLabel)
    }
    
}
