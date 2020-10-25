//
//  ZSAddCardViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/16/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAddCardViewController: UIViewController {
    
    //MARK: - Public variables
    
    var dismissHandler: (() -> Void)?
    
    //MARK: - Private variables
    
    private var sectionSize: CGSize {
        return CGSize(width: self.view.bounds.width / 1.2, height: 60)
    }
    
    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Добавить новую карту"
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var mainView: ZSAddCardView = {
        var view = ZSAddCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "dismiss"), style: .plain,
            target: self, action: #selector(self.dismissButtonTapped))
        button.tintColor = AppColors.textDarkColor.color()
        return button
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
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground
        self.addSubviews()
        self.makeConstraints()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.mainView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
            make.width.equalTo(self.view.frame.width - 40)
        }
        self.doneButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.doneButton)
        self.scrollView.addSubview(self.mainView)
        self.navigationItem.leftBarButtonItem = self.dismissButton
    }
    
    //MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        self.dismissHandler?()
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("done add card")
    }
    
}
