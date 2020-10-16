//
//  ZSCheckoutFinalViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCheckoutFinalViewController: UIViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    
    // MARK: - GUI Variables
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Детали заказа"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mainView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = AppColors.mainColor.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = AppColors.mainColor.color()
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(self.doneButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground
        self.addSubviews()
        self.makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        self.mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(self.view.frame.width - 40)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
            make.height.equalTo(200)
        }
        self.doneButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.doneButton)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.mainView)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("done buy")
    }
    
}
