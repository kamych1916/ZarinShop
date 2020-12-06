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
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset.bottom = 70
        return scroll
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Детали заказа"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var mainView: ZSCheckoutFinalView = {
        var view = ZSCheckoutFinalView()
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .mainColor
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(view.frame.width - 40)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(mainView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(mainView)
        scrollView.addSubview(doneButton)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        let merchantServiceId = 14950
        let merchantId = 10466
        let merchantTransAmount = 1000
        let merchantTransId = 1
        
        guard let url = URL(string: "https://my.click.uz/services/pay/?service_id=\(merchantServiceId)&merchant_id=\(merchantId)&amount=\(merchantTransAmount)&transaction_param=\(merchantTransId)") else { return }
        
        presentSafariVC(with: url)
    }
    
}
