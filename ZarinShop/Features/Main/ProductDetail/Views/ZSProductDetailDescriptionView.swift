//
//  ZSProductDetailDescriptionView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/15/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductDetailDescriptionView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Описание"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppColors.textGoldColor.color()
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
    
    func initView(text: String) {
        self.descriptionLabel.text = text
        
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
    }
    
}
