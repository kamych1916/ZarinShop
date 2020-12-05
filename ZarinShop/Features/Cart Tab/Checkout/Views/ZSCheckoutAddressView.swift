//
//  ZSCheckoutAddressView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/16/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import DropDown

class ZSCheckoutAddressView: UIView {
    
    //MARK: - Public variables
    
    var addAddressButtonTappedHandler: (() -> ())?
    var selectedAddressLabelTappedHandler: (() -> ())?

    //MARK: - GUI variables
    
    lazy var deliveryTypeView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(deliveryTypeViewTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deliveryTypeLabel1: UILabel = {
        var label = UILabel()
        label.text = "Способ доставки"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deliveryTypeLabel2: UILabel = {
        var label = UILabel()
        label.text = "Доставка на адрес"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deliveryTypeDropButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "dropdown")
        image = image?.with(color: .textDarkColor)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addressView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addressTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Адрес доставки"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addAddressButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "plus")
        image = image?.with(color: .textDarkColor)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.text = "Страна:\nГород:\nОбласть:\nУлица:\nДом:\nКвартира:"
        label.numberOfLines = 0
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectAddressLabelTapped))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
        addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        deliveryTypeView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        deliveryTypeLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        
        deliveryTypeLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(deliveryTypeLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        
        deliveryTypeDropButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        
        addressView.snp.updateConstraints { (make) in
            make.top.equalTo(deliveryTypeView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        addressTitleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        addAddressButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(addressTitleLabel.snp.centerY)
            make.size.equalTo(56)
        }
        
        addressLabel.snp.updateConstraints { (make) in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .mainColor
    }
    
    private func addSubviews() {
        addSubview(deliveryTypeView)
        addSubview(addressView)
        deliveryTypeView.addSubview(deliveryTypeLabel1)
        deliveryTypeView.addSubview(deliveryTypeLabel2)
        deliveryTypeView.addSubview(deliveryTypeDropButton)
        addressView.addSubview(addressTitleLabel)
        addressView.addSubview(addAddressButton)
        addressView.addSubview(addressLabel)
    }
    
    //MARK: - Actions
    
    @objc private func selectAddressLabelTapped() {
        selectedAddressLabelTappedHandler?()
    }
    
    @objc private func addAddressButtonTapped() {
        addAddressButtonTappedHandler?()
    }
    
    @objc private func deliveryTypeViewTapped() {
        let dropDown = DropDown()
        dropDown.dataSource = ["Доставка на адрес", "Самовывоз"]
        dropDown.anchorView = deliveryTypeView
        dropDown.layer.cornerRadius = 12
        dropDown.textFont = .systemFont(ofSize: 17)
        dropDown.backgroundColor = .white
        dropDown.bottomOffset = .init(x: 0, y: deliveryTypeView.bounds.maxY)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.deliveryTypeLabel2.text = item
        }
    }
    
}
