//
//  ZSCheckoutView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/25/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit
import DropDown

class ZSCheckoutView: UIView {
    
    //MARK: - Public variables
    
    var selectedAddressLabelTappedHandler: (() -> ())?
    var selectedPaymentSystem: ZSPaymentSystems? = .clickuz
    
    //MARK: - GUI variables
    
    lazy var addressView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectAddressTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var addressTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Адрес доставки"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var addressSelectImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        var image = UIImage(named: "dropdown")
        imageView.image = image
        return imageView
    }()
    
    lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.text = "Страна:\nГород:\nОбласть:\nУлица:\nДом:\nКвартира:"
        label.numberOfLines = 0
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var paymentView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    
    lazy var paymentTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Оплата"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectPaymentTapped))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var paymentSelectImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        var image = UIImage(named: "dropdown")
        imageView.image = image
        return imageView
    }()
    
    lazy var paymentDescriptionLabel1: UILabel = {
        var label = UILabel()
        label.text = "Безналичные (картой)"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    lazy var paymentDescriptionLabel2: UILabel = {
        var label = UILabel()
        label.text = "Оплата наличными, при получении доставки"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    lazy var paymentSystemsView: ZSPaymentSystemsView = {
        var view = ZSPaymentSystemsView()
        view.selectedHandler = { [weak self] system in
            self?.selectedPaymentSystem = system
        }
        return view
    }()
    
    lazy var totalView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    
    lazy var totalTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Итого"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var totalItemsLabel1: UILabel = {
        var label = UILabel()
        label.text = "Всего товаров"
        label.textAlignment = .left
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    lazy var totalItemsLabel2: UILabel = {
        var label = UILabel()
        label.text = "13"
        label.textAlignment = .right
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    lazy var totalPriceLabel1: UILabel = {
        var label = UILabel()
        label.text = "Сумма"
        label.textAlignment = .left
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    lazy var totalPriceLabel2: UILabel = {
        var label = UILabel()
        label.text = "1000 сум"
        label.textAlignment = .right
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        addressView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        addressTitleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        addressSelectImageView.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(addressTitleLabel.snp.centerY)
            make.size.equalTo(32)
        }
        
        addressLabel.snp.updateConstraints { (make) in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        paymentView.snp.updateConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        paymentTitleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
        }
        
        paymentSelectImageView.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(paymentTitleLabel.snp.centerY)
            make.size.equalTo(32)
        }
        
        paymentDescriptionLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(paymentTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        paymentDescriptionLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(paymentDescriptionLabel1.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        paymentSystemsView.snp.makeConstraints { (make) in
            make.top.equalTo(paymentDescriptionLabel1.snp.bottom).offset(20)
            make.left.bottom.equalToSuperview().inset(20)
        }
        
        totalView.snp.updateConstraints { (make) in
            make.top.equalTo(paymentView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        totalTitleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        totalItemsLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(totalTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        
        totalItemsLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(totalTitleLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(20)
        }
        
        totalPriceLabel1.snp.updateConstraints { (make) in
            make.top.equalTo(totalItemsLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        
        totalPriceLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(totalItemsLabel2.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview().inset(20)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .mainColor
        addSubviews()
    }
    
    func addSubviews() {
        addSubview(addressView)
        addressView.addSubview(addressTitleLabel)
        addressView.addSubview(addressSelectImageView)
        addressView.addSubview(addressLabel)
        
        addSubview(paymentView)
        paymentView.addSubview(paymentTitleLabel)
        paymentView.addSubview(paymentSelectImageView)
        paymentView.addSubview(paymentDescriptionLabel1)
        paymentView.addSubview(paymentDescriptionLabel2)
        paymentView.addSubview(paymentSystemsView)
        
        addSubview(totalView)
        totalView.addSubview(totalTitleLabel)
        totalView.addSubview(totalItemsLabel1)
        totalView.addSubview(totalItemsLabel2)
        totalView.addSubview(totalPriceLabel1)
        totalView.addSubview(totalPriceLabel2)
    }
    
    //MARK: - Actions
    
    @objc func selectAddressTapped() {
        selectedAddressLabelTappedHandler?()
    }

    @objc func selectPaymentTapped() {
        let dropDown = DropDown()
        dropDown.dataSource = ["Безналичные (картой)", "Наличными"]
        dropDown.anchorView = paymentView
        dropDown.textFont = .systemFont(ofSize: 17)
        dropDown.backgroundColor = .white
        dropDown.bottomOffset = .init(x: 0, y: paymentView.bounds.midY)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.paymentDescriptionLabel1.text = item
            if index == 0 {
                self.paymentDescriptionLabel2.isHidden = true
                self.paymentSystemsView.isHidden = false
                self.paymentSystemsView.isUserInteractionEnabled = true
                self.selectedPaymentSystem = self.paymentSystemsView.selected
            } else {
                self.paymentDescriptionLabel2.isHidden = false
                self.paymentSystemsView.isHidden = true
                self.paymentSystemsView.isUserInteractionEnabled = false
                self.selectedPaymentSystem = nil
            }
            
        }

    }

}

