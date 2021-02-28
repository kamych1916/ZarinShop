//
//  ZSColorsCollectionViewCell.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/30/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSColorsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ZSColorsCollectionViewCell"
    
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
    
    private lazy var сolorView: UIView = {
        var view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = (contentView.bounds.width * 0.7) / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.textDarkColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 16
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initCell(hexColor: String) {
        self.сolorView.backgroundColor = .init(hex: hexColor)

        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.сolorView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.7)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.сolorView)
    }
    
}
