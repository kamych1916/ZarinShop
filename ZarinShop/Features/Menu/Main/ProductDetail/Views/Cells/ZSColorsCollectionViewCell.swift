//
//  ZSColorsCollectionViewCell.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
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
                    self.contentView.layer.borderColor = AppColors.textDarkColor.color().cgColor
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
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
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
        let hex = "#" + hexColor
        if let color = UIColor(hex: hex) {
            self.сolorView.backgroundColor = color
        }

        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.сolorView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.сolorView)
    }
    
}
