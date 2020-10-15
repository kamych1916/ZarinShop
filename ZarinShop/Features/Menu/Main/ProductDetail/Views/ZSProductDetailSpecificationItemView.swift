//
//  ZSProductDetailSpecificationItemView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/15/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductDetailSpecificationItemView: UIView {

    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionlabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColors.textDarkColor.color()
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
    
    func initView(item: ZSSpecificationModel) {
        self.titleLabel.text = item.title
        self.descriptionlabel.text = item.description
        
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(20)
        }
        self.descriptionlabel.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionlabel)
    }
    
}
