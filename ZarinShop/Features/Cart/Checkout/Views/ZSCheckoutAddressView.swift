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
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var deliveryTypeView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(self.deliveryTypeViewTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryTypeLabel1: UILabel = {
        var label = UILabel()
        label.text = "Способ доставки"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryTypeLabel2: UILabel = {
        var label = UILabel()
        label.text = "Доставка на адрес"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryTypeDropButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "dropdown")
        image = image?.with(color: .textDarkColor)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addressView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addressLabel: UILabel = {
        var label = UILabel()
        label.text = "Адрес доставки"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addAddressButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "plus")
        image = image?.with(color: .textDarkColor)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.addAddressButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addressTextView: UITextView = {
        var textView = UITextView()
        textView.text =
        """
        Город: Ташкент
        Область: Тестовая область
        Улица: Тестовая улица
        Дом: 16
        Квартира: 79
        """
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        textView.font = .systemFont(ofSize: 17, weight: .medium)
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.deliveryTypeView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.deliveryTypeLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.deliveryTypeLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryTypeLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.deliveryTypeDropButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        self.addressView.snp.updateConstraints { (make) in
            make.top.equalTo(self.deliveryTypeView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.addressLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.addAddressButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.addressLabel.snp.centerY)
            make.size.equalTo(56)
        }
        self.addressTextView.snp.updateConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .mainColor
    }
    
    private func addSubviews() {
        self.addSubview(self.deliveryTypeView)
        self.addSubview(self.addressView)
        self.deliveryTypeView.addSubview(self.deliveryTypeLabel1)
        self.deliveryTypeView.addSubview(self.deliveryTypeLabel2)
        self.deliveryTypeView.addSubview(self.deliveryTypeDropButton)
        self.addressView.addSubview(self.addressLabel)
        self.addressView.addSubview(self.addAddressButton)
        self.addressView.addSubview(self.addressTextView)
    }
    
    //MARK: - Actions
    
    @objc private func addAddressButtonTapped() {
        self.addAddressButtonTappedHandler?()
    }
    
    @objc private func deliveryTypeViewTapped() {
        let dropDown = DropDown()
        dropDown.dataSource = ["Доставка на адрес", "Самовывоз"]
        dropDown.anchorView = self.deliveryTypeView
        dropDown.textFont = .systemFont(ofSize: 17)
        dropDown.backgroundColor = .white
        dropDown.bottomOffset = .init(x: 0, y: self.deliveryTypeView.bounds.maxY)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.deliveryTypeLabel2.text = item
        }
    }
    
}
