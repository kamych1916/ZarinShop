//
//  ZSSideMenuFooterView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSideMenuFooterView: UIView {
    
    // MARK: - GUI Variables
    
    private lazy var phoneLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.text = "+996-89-99-74"
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "phone")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.text = "Some street, 17/5"
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "location")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var telegramImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "telegram")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var instagramImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "instagram")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var facebookImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "facebook")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var companyNameLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .left
        label.text = "Zarin Shop"
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.text = "©2020"
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.phoneLabel)
        self.addSubview(self.phoneImageView)
        self.addSubview(self.addressLabel)
        self.addSubview(self.addressImageView)
        self.addSubview(self.companyNameLabel)
        self.addSubview(self.yearLabel)
        self.addSubview(self.telegramImageView)
        self.addSubview(self.instagramImageView)
        self.addSubview(self.facebookImageView)
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.phoneImageView.snp.updateConstraints { (make) in
            make.left.top.equalToSuperview()
            make.size.equalTo(20)
        }
        self.phoneLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.phoneImageView.snp.right).offset(10)
            make.top.right.greaterThanOrEqualToSuperview()
            make.centerY.equalTo(self.phoneImageView.snp.centerY)
        }
        self.addressImageView.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.top.greaterThanOrEqualTo(self.phoneImageView.snp.bottom).offset(10)
            make.size.equalTo(20)
        }
        self.addressLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.addressImageView.snp.right).offset(10)
            make.top.equalTo(self.phoneLabel.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.centerY.equalTo(self.addressImageView.snp.centerY)
        }
        self.facebookImageView.snp.updateConstraints { (make) in
            make.right.bottom.lessThanOrEqualToSuperview()
            make.top.equalTo(self.addressLabel.snp.bottom).offset(10)
            make.size.equalTo(32)
        }
        self.instagramImageView.snp.updateConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(10)
            make.right.equalTo(self.facebookImageView.snp.left).offset(-20)
            make.bottom.lessThanOrEqualToSuperview()
            make.size.equalTo(32)
        }
        self.telegramImageView.snp.updateConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(10)
            make.right.equalTo(self.instagramImageView.snp.left).offset(-20)
            make.bottom.lessThanOrEqualToSuperview()
            make.size.equalTo(32)
        }
        self.companyNameLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.addressImageView.snp.bottom).offset(10)
        }
        self.yearLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.companyNameLabel.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview()
        }
        super.updateConstraints()
    }
    
}
