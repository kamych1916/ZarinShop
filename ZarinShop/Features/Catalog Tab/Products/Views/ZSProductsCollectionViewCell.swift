//
//  ZSProductsCollectionViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ZSProductsCollectionViewCell"
    
    // MARK: - GUI Variables
    
    lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var bigImageContainerView: UIView = {
        var view = UIView()
        return view
    }()
    
    lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    lazy var favoriteImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "favorite")
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(favoriteImageViewTapped))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .textDarkColor
        label.alpha = 0.5
        label.textAlignment = .left
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(bigImageContainerView)
        bigImageContainerView.addSubview(bigImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        bigImageView.addSubview(favoriteImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bigImageView.dropShadow(
            conteinerView: bigImageContainerView, color: .black, opacity: 0.4,
            offSet: .init(width: 0, height: 4), radius: 4)
    }
    
    func initCell(with model: ZSProductModel) {
        titleLabel.text = model.name
        descriptionLabel.text = String(format: "%0.2f", model.price) + " сум"
        if model.image.count > 0 {
            //todo
            bigImageView.image = UIImage(named: "defauldProduct")
            //loadImage(from: model.image[0])
        } else {
            bigImageView.image = UIImage(named: "defauldProduct")
        }
        
        layoutIfNeeded()
        setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        //bigImageView.image = nil
        favoriteImageView.image = UIImage(named: "favorite")
    }
    
    // MARK: - Constraints

    override func updateConstraints() {
        containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        bigImageContainerView.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        bigImageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        favoriteImageView.snp.updateConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        titleLabel.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bigImageContainerView.snp.bottom).offset(10)
        }
        descriptionLabel.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func favoriteImageViewTapped() {
        favoriteImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        favoriteImageView.alpha = 0.5
        UIView.animate(withDuration: 0.5) {
            self.favoriteImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.favoriteImageView.alpha = 1
            self.favoriteImageView.image = UIImage(named: "favoriteHighlighted")
        }
        NotificationCenter.default.post(name: .favoritesValueChanged, object: nil)
    }
    
    // MARK: - Helpers
    
    private func loadImage(from url: String) {
        guard let imageURL = URL(string: (url)) else {
            bigImageView.image = UIImage(named: "defauldProduct")
            return
        }
        bigImageView.kf.indicatorType = .activity
        bigImageView.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ],
            completionHandler:  { response in
                switch response {
                case .success(let value):
                    self.bigImageView.image = value.image
                case .failure(_):
                    self.bigImageView.image = UIImage(named: "defauldProduct")
                }
            })
    }
}
