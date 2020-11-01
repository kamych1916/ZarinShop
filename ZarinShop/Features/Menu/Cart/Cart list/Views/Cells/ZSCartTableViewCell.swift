//
//  ZSCartTableViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/5/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCartTableViewCell: UITableViewCell {
    
    static let reuseId = "ZSCartTableViewCell"
    
    var productCount: Int {
        return self.productCount
    }
    
    // MARK: - Private Variables
    
    private var _productCount: Int = 1 {
        willSet {
            self.countLabel.text = "\(newValue)x"
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - GUI Variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stepperContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.mainColor.color().cgColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var incrementButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        button.setTitleColor(AppColors.mainColor.color(), for: .normal)
        button.addTarget(self, action: #selector(self.incrementTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var decrementButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        button.setTitleColor(AppColors.mainColor.color(), for: .normal)
        button.addTarget(self, action: #selector(self.decrementTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.text = "Цвет:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .left
        label.text = "Размер: М"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.text = "1х"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.text = "2050 сум"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell(model: CartItemModel) {
        self.titleLabel.text = "\(model.id)"
        self.priceLabel.text = "\(model.price)"
        if model.image.count > 0 {
            self.loadImage(from: model.image[0])
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        self._productCount = 0
        self.bigImageView.image = nil
    }

    
    // MARK: - Constraints
    
    override func updateConstraints() {
        
        self.containerView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        self.bigImageView.snp.updateConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 80, height: 120))
        }
        self.stepperContainerView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        self.incrementButton.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.size.equalTo(40)
        }
        self.decrementButton.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.incrementButton.snp.bottom)
            make.size.equalTo(40)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.bigImageView.snp.right).offset(20)
            make.top.equalToSuperview().inset(10)
            make.right.lessThanOrEqualTo(self.stepperContainerView.snp.left)
        }
        self.colorLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.bigImageView.snp.right).offset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
        }
        self.colorView.snp.updateConstraints { (make) in
            make.left.equalTo(self.colorLabel.snp.right).offset(10)
            make.centerY.equalTo(self.colorLabel.snp.centerY)
            make.size.equalTo(12)
        }
        self.sizeLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.colorView.snp.right).offset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.right.lessThanOrEqualTo(self.stepperContainerView.snp.left)
        }
        self.countLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.bigImageView.snp.right).offset(20)
            make.top.greaterThanOrEqualTo(self.colorLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(40)
        }
        self.priceLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.countLabel.snp.right).offset(20)
            make.centerY.equalTo(self.countLabel.snp.centerY)
            make.bottom.equalToSuperview().inset(10)
        }
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.bigImageView)
        self.containerView.addSubview(self.stepperContainerView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.colorLabel)
        self.containerView.addSubview(self.colorView)
        self.containerView.addSubview(self.sizeLabel)
        self.containerView.addSubview(self.countLabel)
        self.containerView.addSubview(self.priceLabel)
        self.stepperContainerView.addSubview(self.incrementButton)
        self.stepperContainerView.addSubview(self.decrementButton)
    }
    
    // MARK: - Actions
    
    @objc private func incrementTapped() {
        self._productCount += 1
    }
    
    @objc private func decrementTapped() {
        if self._productCount > 1 {
            self._productCount -= 1
        }
    }
    
    // MARK: - Helpers
    
    private func loadImage(from url: String) {
        guard let imageURL = URL(string: (url)) else { return }
        self.bigImageView.kf.indicatorType = .activity
        self.bigImageView.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ])
    }
}
