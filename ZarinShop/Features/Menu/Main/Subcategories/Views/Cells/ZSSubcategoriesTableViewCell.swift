//
//  ZSSubcategoriesTableViewCell.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/20/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import Kingfisher

class ZSSubcategoriesTableViewCell: UITableViewCell {
    
    static let identifier = "ZSSubcategoriesTableViewCell"
    
    // MARK: - Private Variables
    
    // MARK: - GUI Variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var darkOverView: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "men")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.textColor = AppColors.mainLightColor.color()
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColors.mainLightColor.color()
        label.textAlignment = .center
        label.isHidden = true
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell(with model: ZSSubcategoriesModel) {
        self.titleLabel.text = model.name
        //self.loadImage(from: model.image_url)
        
        self.setNeedsUpdateConstraints()
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        
        self.containerView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        self.darkOverView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.bigImageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.countLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.insertSubview(self.bigImageView, at: 0)
        self.containerView.insertSubview(self.darkOverView, at: 1)
        self.containerView.insertSubview(self.titleLabel, at: 2)
        self.containerView.insertSubview(self.countLabel, at: 3)
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
