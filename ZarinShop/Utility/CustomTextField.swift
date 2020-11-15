//
//  CustomTextField.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 11/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    private func setup() {
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.borderStyle = .none
        self.layer.cornerRadius = 20
        self.backgroundColor = AppColors.mainLightColor.color()
        self.textColor = AppColors.textDarkColor.color()
        self.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        self.leftViewMode = .always
        self.placeholder = "Имя"
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
