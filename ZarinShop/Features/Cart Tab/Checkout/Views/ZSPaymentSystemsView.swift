//
//  ZSPaymentSystemsView.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 06/12/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSPaymentSystemsView: UIView {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    var selectedHandler: ((ZSPaymentSystems) -> ())?
    
    var selected: ZSPaymentSystems = .clickuz
    
    //MARK: - GUI variables
    
    lazy var firstView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(firstViewTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var firstImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "clickuz")
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var secondView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(secondViewTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var secondImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "payme")
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var thirdView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(thirdViewTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var thirdImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "uzcard")
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
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
        
        firstView.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(40)
        }
        
        firstImageView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(38)
        }
        
        secondView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(firstView.snp.right).offset(10)
            make.size.equalTo(40)
        }
        
        secondImageView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(38)
        }
        
        thirdView.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(secondView.snp.right).offset(10)
            make.size.equalTo(40)
        }
        
        thirdImageView.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(38)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func setup() {
        
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(firstView)
        firstView.addSubview(firstImageView)
        
        addSubview(secondView)
        secondView.addSubview(secondImageView)
        
        addSubview(thirdView)
        thirdView.addSubview(thirdImageView)
    }
    
    //MARK: - Actions
    
    @objc private func firstViewTapped() {
        firstView.layer.borderWidth = 1
        secondView.layer.borderWidth = 0
        thirdView.layer.borderWidth = 0
        
        selectedHandler?(.clickuz)
        selected = .clickuz
    }
    
    @objc private func secondViewTapped() {
        firstView.layer.borderWidth = 0
        secondView.layer.borderWidth = 1
        thirdView.layer.borderWidth = 0
        
        selectedHandler?(.payme)
        selected = .payme
    }
    
    @objc private func thirdViewTapped() {
        firstView.layer.borderWidth = 0
        secondView.layer.borderWidth = 0
        thirdView.layer.borderWidth = 1
        
        selectedHandler?(.uzcard)
        selected = .uzcard
    }
    
}
