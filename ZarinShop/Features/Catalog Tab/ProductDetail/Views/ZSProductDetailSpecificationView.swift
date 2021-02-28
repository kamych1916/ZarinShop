//
//  ZSProductDetailSpecificationView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/15/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSProductDetailSpecificationView: UIView {

    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Особенности"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .left
        return label
    }()
    
    lazy var firstItem: ZSProductDetailSpecificationColors = {
        var view = ZSProductDetailSpecificationColors()
        return view
    }()

    lazy var secondItem: ZSProductDetailSpecificationSizes = {
        var view = ZSProductDetailSpecificationSizes()
        return view
    }()
    
    lazy var thirdItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        return view
    }()
    
    lazy var fourthItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainLightColor
        layer.cornerRadius = 20
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
    }
    
    func initView(colors: [ZSLinkColorModel], sizes: [String], model: ZSSpecificationModel, country: ZSSpecificationModel) {
        firstItem.initView(colors: colors)
        secondItem.initView(sizes: sizes)
        thirdItem.initView(item: model)
        fourthItem.initView(item: country)
        setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        titleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        firstItem.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        secondItem.snp.updateConstraints { (make) in
            make.top.equalTo(firstItem.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        thirdItem.snp.updateConstraints { (make) in
            make.top.equalTo(secondItem.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        fourthItem.snp.updateConstraints { (make) in
            make.top.equalTo(thirdItem.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(firstItem)
        addSubview(secondItem)
        addSubview(thirdItem)
        addSubview(fourthItem)
    }
    
}
