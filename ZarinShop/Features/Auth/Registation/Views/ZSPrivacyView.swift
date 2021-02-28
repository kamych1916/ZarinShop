//
//  ZSPrivacyView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 11/14/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSPrivacyView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Нажимая продолжить вы принимаете"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var privacyButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var confidencialButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        
    }
    
}
