//
//  ZSCheckoutPaymentView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/16/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import DropDown

class ZSCheckoutPaymentView: UIView {
    
    //MARK: - Public variables
    
    var addCardButtonTappedHandler: (() -> ())?
    var paymentTypeDropButtonTappedHandler: (() -> ())?
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var paymentTypeView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(self.paymentTypeViewTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentTypeLabel1: UILabel = {
        var label = UILabel()
        label.text = "Способ оплаты"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentTypeLabel2: UILabel = {
        var label = UILabel()
        label.text = "Безналичные (картой)"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentTypeDropButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "dropdown")
        image = image?.with(color: .textDarkColor)
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
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
        label.text = "Карта"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "**********3456"
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardDetailIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        var image = UIImage(named: "creditCard")
        imageView.image = image?.with(color: .mainColor)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var addCardButton: UIButton = {
        var button = UIButton()
        var image = UIImage(named: "plus")
        image = image?.with(color: .textDarkColor)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.addCardButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        self.paymentTypeView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.paymentTypeLabel1.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.paymentTypeLabel2.snp.updateConstraints { (make) in
            make.top.equalTo(self.paymentTypeLabel1.snp.bottom).offset(10)
            make.left.bottom.equalToSuperview().inset(20)
        }
        self.paymentTypeDropButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        self.cardDetailView.snp.updateConstraints { (make) in
            make.top.equalTo(self.paymentTypeView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.cardDetailLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.addCardButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.cardDetailLabel.snp.centerY)
            make.size.equalTo(56)
        }
        self.cardDetailIcon.snp.updateConstraints { (make) in
            make.top.equalTo(self.cardDetailLabel.snp.bottom).offset(10)
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
    
    private func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = .mainColor
    }
    
    private func addSubviews() {
        self.addSubview(self.paymentTypeView)
        self.addSubview(self.cardDetailView)
        self.paymentTypeView.addSubview(self.paymentTypeLabel1)
        self.paymentTypeView.addSubview(self.paymentTypeLabel2)
        self.paymentTypeView.addSubview(self.paymentTypeDropButton)
        self.cardDetailView.addSubview(self.cardDetailLabel)
        self.cardDetailView.addSubview(self.addCardButton)
        self.cardDetailView.addSubview(self.cardDetailIcon)
        self.cardDetailView.addSubview(self.cardNumberLabel)
    }
    
    //MARK: - Actions
    
    @objc private func addCardButtonTapped() {
        self.addCardButtonTappedHandler?()
    }
    
    @objc private func paymentTypeViewTapped() {
        let dropDown = DropDown()
        dropDown.dataSource = ["Безналичные (картой)", "Наличные"]
        dropDown.anchorView = self.paymentTypeView
        dropDown.textFont = .systemFont(ofSize: 17)
        dropDown.backgroundColor = .white
        dropDown.bottomOffset = .init(x: 0, y: self.paymentTypeView.bounds.maxY)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.paymentTypeLabel2.text = item
        }
    }
    
}
