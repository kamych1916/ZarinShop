//
//  ZSSizesTableViewCell.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSizesTableViewCell: UITableViewCell {
    
    //MARK: - Public variables
    
    static let identifier = "ZSSizesTableViewCell"
    
    //MARK: - GUI variables

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "M"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Средний"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.addSubviews()
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initCell(_ title: String, _ description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(10)
            make.width.equalTo(50)
        }
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
    }
    
}
