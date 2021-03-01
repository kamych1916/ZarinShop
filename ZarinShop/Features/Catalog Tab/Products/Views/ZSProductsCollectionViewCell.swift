//
//  ZSProductsCollectionViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSProductsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ZSProductsCollectionViewCell"
    
    private var product: ZSProductModel?
    private var favoriteStorage = FavoritesStorage()

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
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "favorite")
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(favoriteImageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isHidden = !UserDefaults.standard.isSingin()
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
            offSet: .init(width: 0, height: 4), radius: 4, bounds: bigImageView.bounds)
    }
    
    func initCell(with model: ZSProductModel) {
        self.product = model
        titleLabel.text = model.name
        descriptionLabel.text = "\(Int(model.price)) сум"
        if model.images.count > 0 {
            loadImage(from: model.images[0])
        } else {
            bigImageView.image = UIImage(named: "defauldProduct")
        }
        
        favoriteImageView.image = model.isFavorite ?
            UIImage(named: "favoriteHighlighted") :
            UIImage(named: "favorite")
        
        layoutIfNeeded()
        setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        //bigImageView.image = nil
        favoriteImageView.image = UIImage(named: "favorite")
        favoriteImageView.isHidden = !UserDefaults.standard.isSingin()
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
        guard let product = product else { return }
        favoriteImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        favoriteImageView.alpha = 0.5
        UIView.animate(withDuration: 0.5) {
            self.favoriteImageView.transform = .identity
            self.favoriteImageView.alpha = 1
            self.favoriteImageView.image = !product.isFavorite ?
                UIImage(named: "favoriteHighlighted") :
                UIImage(named: "favorite")
        }
        changeFavorite()
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
    
    private func changeFavorite() {
        guard let product = product else { return }
        
        topMostController()?.startLoading()
        
        let path: ZSURLPath = product.isFavorite ? .removeFromFav : .addToFav
        
        ZSNetwork.shared.request(url: path, method: .post, parameters: ["id": product.id])
        { [weak self] (response: Result<[Int], ZSNetworkError>) in
            guard let self = self else { return}
            self.topMostController()?.stopLoading()
            switch response {
            case .success(let serverFavorites):
                self.favoriteStorage.favorites = []
                for id in serverFavorites {
                    self.favoriteStorage.favorites.append(FavoritesModel(id: "\(id)"))
                }
            case .failure(let error):
                self.topMostController()?.alertError(message: error.getDescription())
            }
        }
        
    }
}
