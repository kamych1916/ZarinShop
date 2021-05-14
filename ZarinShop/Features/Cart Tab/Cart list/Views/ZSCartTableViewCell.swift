//
//  ZSCartTableViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/5/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSCartTableViewCell: UITableViewCell {
    
    static let reuseId = "ZSCartTableViewCell"
    var didLoaded = false
    var product: CartItemModel?

    // MARK: - GUI Variables
    
    lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var stepperView: ZSStepperView = {
        var stepper = ZSStepperView()
        stepper.valueDidChangedHandler = { [weak self] value in
            
        }
        stepper.isHidden = true
        return stepper
    }()
    
    lazy var countLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .right
        label.text = "10 шт."
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        return label
    }()
    
    lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .left
        label.text = "Размер:"
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell(model: CartItemModel) {
        product = model
        didLoaded = true
        titleLabel.text = "\(model.name)"
        stepperView.value = model.kol
        sizeLabel.text = "Размер: \(model.size ?? "")"
        priceLabel.text = "\(Int(model.price)) сум"
        countLabel.text = "\(model.kol) шт."
        if model.images.count > 0 {
            loadImage(from: model.images[0])
        } else {
            bigImageView.image = UIImage(named: "defauldProduct")
        }
        
        setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bigImageView.image = nil
        product = nil
        didLoaded = false
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        
        containerView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        bigImageView.snp.updateConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 80, height: 120))
        }
        
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(bigImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        sizeLabel.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(bigImageView.snp.right).offset(16)
            make.right.lessThanOrEqualToSuperview().inset(20)
        }
        
        priceLabel.snp.updateConstraints { (make) in
            make.left.equalTo(bigImageView.snp.right).offset(16)
            make.top.greaterThanOrEqualTo(sizeLabel.snp.bottom)
            make.right.equalTo(countLabel.snp.left).offset(8)
            make.bottom.equalToSuperview().inset(10)
        }
        
        stepperView.snp.updateConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        countLabel.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(bigImageView)
        containerView.addSubview(stepperView)
        containerView.addSubview(countLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(sizeLabel)
        containerView.addSubview(priceLabel)
    }
    
    // MARK: - Helpers
    
    private func loadImage(from url: String) {
        guard let imageURL = URL(string: (url)) else { return }
        
        bigImageView.kf.indicatorType = .activity
        bigImageView.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ])
    }
    
}
