//
//  ZSFavoriteTableCell.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 10/01/21.
//  Copyright © 2021 ZarinShop. All rights reserved.
//

import UIKit

class ZSFavoriteTableCell: UITableViewCell {
    
    static let reuseId = "ZSFavoriteTableCell"
    var didLoaded = false

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
    
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .textDarkColor
        label.numberOfLines = 2
        label.textAlignment = .left
        label.text = "Цвет:"
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        label.text = "2050 сум"
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

    func initCell(model: ZSProductModel) {
        didLoaded = true
        titleLabel.text = model.name
        descriptionLabel.text = model.description
        priceLabel.text = "\(model.price) сум"
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
        
        descriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(bigImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }

        priceLabel.snp.updateConstraints { (make) in
            make.left.equalTo(bigImageView.snp.right).offset(16)
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(10)
        }
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(bigImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
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
