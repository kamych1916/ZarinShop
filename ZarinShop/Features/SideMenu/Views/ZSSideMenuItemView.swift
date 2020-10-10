//
//  ZSSideMenuItemView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSideMenuItemView: UIView {
    
    // MARK: - GUI Variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView(image: UIImage?, title: String) {
        self.addSubviews()
        self.imageView.image = image
        self.titleLabel.text = title
        self.needsUpdateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
        self.containerView.addSubview(self.titleLabel)
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(25)
            make.centerY.equalToSuperview()
        }
        super.updateConstraints()
    }
    
}
