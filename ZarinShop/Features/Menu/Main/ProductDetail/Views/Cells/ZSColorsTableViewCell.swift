//
//  ZSColorsTableViewCell.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSColorsTableViewCell: UITableViewCell {
    
    //MARK: - Public variables
    
    static let identifier = "ZSColorsTableViewCell"
    
    //MARK: - GUI variables
    
    private lazy var сolorView: UIView = {
        var view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var currencyLabel: UILabel = {
        var label = UILabel()
        label.text = "Красный"
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
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.сolorView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview()
            make.size.equalTo(48)
        }
        self.currencyLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.сolorView.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.contentView.addSubview(self.сolorView)
        self.contentView.addSubview(self.currencyLabel)
    }
    
}
