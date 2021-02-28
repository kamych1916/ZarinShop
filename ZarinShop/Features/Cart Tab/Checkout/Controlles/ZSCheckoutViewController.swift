//
//  ZSCheckoutViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit
import ColorMatchTabs

class ZSCheckoutViewController: ZSBaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    
    private var cartItems: [CartItemModel]
    private var total: Double
    private var selectedAddress: AddressModel?
    
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
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .mainColor
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(cartItems: [CartItemModel], total: Double) {
        self.cartItems = cartItems
        self.total = total
        let addresses = AddressStorage().addresses
        self.selectedAddress = addresses.first
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Заказ"
        view.backgroundColor = .groupTableViewBackground
        updateAddressWith(selectedAddress)
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
        let listItems: [[String: Any]] = cartItems.map {$0.dictionaryDescription}
        let params: [String: Any] = [
            "list_items": listItems,
            "which_bank": mainView.selectedPaymentSystem!.rawValue,
            "shipping_adress": selectedAddress != nil ? selectedAddress!.fullInfo : "Нет адреса",
            "shipping_type": "delivery",
            "subtotal": total
        ]
        
        let paymentDetailsVC = ZSCheckoutPaymentDetailsViewController(params: params)
        navigationController?.pushViewController(paymentDetailsVC, animated: true)
    }
    
    // MARK: - Helpers
    
    private func updateAddressWith(_ address: AddressModel?) {
        guard let address = address else { return }
        mainView.addressLabel.text = address.fullInfo
    }
    
}
