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
        label.textColor = .textDarkColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var firstItem: ZSProductDetailSpecificationColors = {
        var view = ZSProductDetailSpecificationColors()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var secondItem: ZSProductDetailSpecificationSizes = {
        var view = ZSProductDetailSpecificationSizes()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var thirdItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var fourthItem: ZSProductDetailSpecificationItemView = {
        var view = ZSProductDetailSpecificationItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .mainLightColor
        self.layer.cornerRadius = 20
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initView(colors: [LinkColorModel], sizes: [String], model: ZSSpecificationModel, country: ZSSpecificationModel) {
        self.firstItem.initView(colors: colors)
        self.secondItem.initView(sizes: sizes)
        self.thirdItem.initView(item: model)
        self.fourthItem.initView(item: country)
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
