//
//  ZSStepperView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 29/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSStepperView: UIView {
    
    //MARK: - Public variables
    
    var valueDidChangedHandler: ((Int) -> ())?
    var maxValue: Int?
    var value: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
            valueDidChangedHandler?(value)
        }
    }
    
    //MARK: - GUI variables
    
    lazy var valueLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textDarkColor
        label.textAlignment = .center
        return label
    }()
    
    lazy var incrementButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.textDarkColor, for: .normal)
        button.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var decrementButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.textDarkColor, for: .normal)
        button.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        incrementButton.snp.updateConstraints { (make) in
            make.left.equalTo(valueLabel.snp.right)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        valueLabel.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(decrementButton.snp.right)
            make.width.equalTo(30)
        }
        
        decrementButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func setup() {
        backgroundColor = .white
        clipsToBounds = true
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(decrementButton)
        addSubview(valueLabel)
        addSubview(incrementButton)
    }
    
    //MARK: - Actions
    
    @objc private func incrementTapped() {
        guard let max = maxValue,
              value < max else { return }
        value += 1
    }
    
    @objc private func decrementTapped() {
        if value > 1 {
            value -= 1
        }
    }
    
}
