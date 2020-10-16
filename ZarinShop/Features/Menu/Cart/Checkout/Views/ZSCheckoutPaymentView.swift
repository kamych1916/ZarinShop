//
//  ZSCheckoutPaymentView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/16/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCheckoutPaymentView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var cardView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardLabel1: UILabel = {
        var label = UILabel()
        label.text = "Добавить карту"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardLabel2: UILabel = {
        var label = UILabel()
        label.text = "Master card/Visa"
        label.textColor = AppColors.textDarkColor.color().withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardAddButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "plus")
        image = image?.imageWithColor(color: AppColors.textDarkColor.color())
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cardDetailView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardDetailLabel: UILabel = {
        var label = UILabel()
        label.text = "Адрес доставки"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "**********3456"
        label.textColor = AppColors.textDarkColor.color().withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardDetailIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        var image = UIImage(named: "creditCard")
        imageView.image = image?.imageWithColor(color: AppColors.mainColor.color())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = AppColors.mainColor.color()
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.cardView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.cardLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.cardLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.cardLabel1.snp.bottom)
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.cardAddButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        self.cardDetailView.snp.updateConstraints { (make) in
            make.top.equalTo(self.cardView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.cardDetailLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.cardDetailIcon.snp.updateConstraints { (make) in
            make.top.equalTo(self.cardDetailLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        self.cardNumberLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.cardDetailIcon.snp.right).offset(10)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.centerY.equalTo(self.cardDetailIcon.snp.centerY)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.cardView)
        self.addSubview(self.cardDetailView)
        self.cardView.addSubview(self.cardLabel1)
        self.cardView.addSubview(self.cardLabel2)
        self.cardView.addSubview(self.cardAddButton)
        self.cardDetailView.addSubview(self.cardDetailLabel)
        self.cardDetailView.addSubview(self.cardDetailIcon)
        self.cardDetailView.addSubview(self.cardNumberLabel)
    }
    
}
