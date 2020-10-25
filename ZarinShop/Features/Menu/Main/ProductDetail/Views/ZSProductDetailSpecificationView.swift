//
//  ZSProductDetailSpecificationView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/15/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductDetailSpecificationView: UIView {

    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Особенности"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var firstItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var secondItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var thirdItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fourthItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = AppColors.mainLightColor.color()
        self.layer.cornerRadius = 20
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initView(items: [ZSSpecificationModel]) {
        self.firstItem.initView(item: items[0])
        self.secondItem.initView(item: items[1])
        self.thirdItem.initView(item: items[2])
        self.fourthItem.initView(item: items[3])
        
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.firstItem.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        self.secondItem.snp.updateConstraints { (make) in
            make.top.equalTo(self.firstItem.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        self.thirdItem.snp.updateConstraints { (make) in
            make.top.equalTo(self.secondItem.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        self.fourthItem.snp.updateConstraints { (make) in
            make.top.equalTo(self.thirdItem.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.firstItem)
        self.addSubview(self.secondItem)
        self.addSubview(self.thirdItem)
        self.addSubview(self.fourthItem)
    }
    
}
