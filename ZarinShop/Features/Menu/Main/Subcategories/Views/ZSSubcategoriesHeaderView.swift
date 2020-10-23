//
//  ZSSubcategoriesHeaderView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSubcategoriesHeaderView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - GUI variables
    
    private lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "category")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Товаров"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        var label = UILabel()
        label.text = "217"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var showAllButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitle("Показать все", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.bigImageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.titleView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(30)
        }
        self.countLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(10)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.countLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(10)
        }
        self.showAllButton.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.bigImageView)
        self.addSubview(self.titleView)
        self.addSubview(self.showAllButton)
        self.titleView.addSubview(self.countLabel)
        self.titleView.addSubview(self.titleLabel)
    }
    
}
