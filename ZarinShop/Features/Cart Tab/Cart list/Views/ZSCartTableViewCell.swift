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

    // MARK: - GUI Variables
    
    lazy var containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bigImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stepperView: ZSStepperView = {
        var stepper = ZSStepperView()
        return stepper
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var colorLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .left
        label.text = "Цвет:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var colorView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .left
        label.text = "Размер: М"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        label.text = "2050 сум"
        label.translatesAutoresizingMaskIntoConstraints = false
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
        titleLabel.text = "\(model.name)"
        stepperView.value = model.kol
        sizeLabel.text = "Размер: \(model.size)"
        priceLabel.text = "\(model.price) сум"
        colorView.backgroundColor = UIColor(hex: "#\(model.color)")
        if model.image.count > 0 {
            //todo
            bigImageView.image = UIImage(named: "defauldProduct")
            //loadImage(from: model.image[0])
        } else {
            bigImageView.image = UIImage(named: "defauldProduct")
        }
        
        setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bigImageView.image = nil
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
            make.left.equalTo(bigImageView.snp.right).offset(20)
        }
        
        colorLabel.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(bigImageView.snp.right).offset(16)
        }
        
        colorView.snp.updateConstraints { (make) in
            make.left.equalTo(colorLabel.snp.right).offset(10)
            make.centerY.equalTo(colorLabel.snp.centerY)
            make.size.equalTo(16)
        }
        
        sizeLabel.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(colorView.snp.right).offset(20)
        }
        
        priceLabel.snp.updateConstraints { (make) in
            make.left.equalTo(bigImageView.snp.right).offset(20)
            make.top.greaterThanOrEqualTo(colorLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(10)
        }
        
        stepperView.snp.updateConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(bigImageView)
        containerView.addSubview(stepperView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(colorLabel)
        containerView.addSubview(colorView)
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
