//
//  ZSCheckoutViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import ColorMatchTabs

class ZSCheckoutViewController: ZSBaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    
    // MARK: - GUI Variables
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset.bottom = 100
        return scroll
    }()
    
    lazy var contentView: UIView = {
        var view = UIView()
        return view
    }()

    lazy var mainView: ZSCheckoutView = {
        var view = ZSCheckoutView()
        view.selectedAddressLabelTappedHandler = { [weak self] in
            let controller = ZSAdressViewController(isPresented: true)
            let navController = UINavigationController(rootViewController: controller)
            controller.selectedAddressHandler = { [weak self] address in
                self?.updateAddressWith(address)
            }
            self?.present(navController, animated: true, completion: nil)
        }
        return view
    }()
    
    lazy var doneButton: UIButton = {
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
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Заказ"
        view.backgroundColor = .groupTableViewBackground
        let addresses = AddressStorage().addresses
        updateAddressWith(addresses.first)
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        mainView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
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
        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)
        contentView.addSubview(doneButton)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        let merchantServiceId = 14950
        let merchantId = 10466
        let merchantTransAmount = 1000
        let merchantTransId = 1
        
        guard let url = URL(string: "https://my.click.uz/services/pay/?service_id=\(merchantServiceId)&merchant_id=\(merchantId)&amount=\(merchantTransAmount)&transaction_param=\(merchantTransId)") else { return }
        
        print(mainView.selectedPaymentSystem)
        //presentSafariVC(with: url)
    }
    
    // MARK: - Helpers
    
    private func updateAddressWith(_ address: AddressModel?) {
        
        guard let address = address else { return }
        
        var string = "Страна: \(address.country)\n"
        string += "Город: \(address.city)\n"
        string += "Область: \(address.district)\n"
        string += "Улица: \(address.street)\n"
        string += "Дом: \(address.house)\n"
        string += "Квартира: \(address.apartment)\n"
        string += "Индекс: \(address.index)\n"
        
        mainView.addressLabel.text = string
    }
    
}
