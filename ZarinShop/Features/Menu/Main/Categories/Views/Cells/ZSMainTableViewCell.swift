//
//  ZSMainTableViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import Kingfisher

class ZSMainTableViewCell: UITableViewCell {
    
    static let reuseId = "ZSMainTableViewCell"
    
    // MARK: - Private Variables
    
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
        label.textColor = AppColors.textGoldColor.color()
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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

    func initCell(with model: ZSCategoriesModel) {
        self.countLabel.text = "\(model.kol)"
        self.titleLabel.text = model.name
        self.loadImage(from: model.image_url)
        
        self.setNeedsUpdateConstraints()
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        
        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
        self.bigImageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.titleView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(80)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        self.countLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.bigImageView)
        self.containerView.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.countLabel)
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
