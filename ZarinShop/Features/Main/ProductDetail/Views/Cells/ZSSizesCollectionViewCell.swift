//
//  ZSSizesCollectionViewCell.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSizesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ZSSizesCollectionViewCell"
    
    //MARK: - Public variables
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.33) {
                    self.contentView.layer.borderWidth = 1.2
                    self.contentView.layer.borderColor = UIColor.textDarkColor.cgColor
                }
            } else {
                UIView.animate(withDuration: 0.33) {
                    self.contentView.layer.borderWidth = 0
                    self.contentView.layer.borderColor = .none
                }
            }
        }
    }
    
    //MARK: - GUI variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.text = "L"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 16
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initCell(size: String) {
        self.sizeLabel.text = size
        
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.7)
        }
        self.sizeLabel.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.sizeLabel)
    }
    
}
