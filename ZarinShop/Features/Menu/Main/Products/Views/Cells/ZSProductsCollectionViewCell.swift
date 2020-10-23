//
//  ZSProductsCollectionViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductsCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "ZSProductsCollectionViewCell"
    
    // MARK: - GUI Variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "favorite")
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(self.favoriteImageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = AppColors.textDarkColor.color()
        label.alpha = 0.5
        label.textAlignment = .left
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.bigImageView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.descriptionLabel)
        self.bigImageView.addSubview(self.favoriteImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell(with model: ZSProductModel) {
        self.titleLabel.text = model.name
        self.descriptionLabel.text = String(format: "%0.2f", model.price) + " сум"
        self.loadImage(from: model.image)
        
        self.setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        //self.bigImageView.image = nil
        self.favoriteImageView.image = UIImage(named: "favorite")
    }
    
    // MARK: - Constraints

    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        self.bigImageView.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.favoriteImageView.snp.updateConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.bigImageView.snp.bottom).offset(10)
        }
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func favoriteImageViewTapped() {
        self.favoriteImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.favoriteImageView.alpha = 0.5
        UIView.animate(withDuration: 0.5) {
            self.favoriteImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.favoriteImageView.alpha = 1
            self.favoriteImageView.image = UIImage(named: "favoriteHighlighted")
        }
        NotificationCenter.default.post(name: .favoritesValueChanged, object: nil)
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
