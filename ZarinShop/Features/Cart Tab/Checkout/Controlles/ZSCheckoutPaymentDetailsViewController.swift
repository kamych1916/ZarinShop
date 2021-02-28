//
//  ZSCheckoutPaymentDetailsViewController.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 20.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import Foundation

import UIKit

class ZSCheckoutPaymentDetailsViewController: ZSBaseViewController {
    
    //MARK: - Private variables
    
    private var params: [String: Any]
    private var paymentDetails: PaymentDetailsModel?
    
    private var isDoneButtonEnable: Bool = false {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.doneButton.backgroundColor = .mainColor
                    self.doneButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.doneButton.backgroundColor = .mainLightColor
                    self.doneButton.isEnabled = false
                }
            }
        }
    }
    
    //MARK: - GUI variables
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset.bottom = 70
        return scroll
    }()
    
    lazy var mainView: ZSPaymentDetailView = {
        var view = ZSPaymentDetailView()
        for field in view.subviews where field is UITextField {
            if let field = field as? UITextField {
                field.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
            }
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
    
    init(params: [String: Any]) {
        self.params = params
        self.paymentDetails = PaymentDetailsStorage().paymentDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Платежные реквизиты"
        
        view.backgroundColor = .groupTableViewBackground
        hideKeyboardWhenTappedAround()
        addSubviews()
        makeConstraints()
        setupPaymentDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
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
    
    //MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        scrollView.addSubview(doneButton)
    }
    
    private func setupPaymentDetails() {
        guard let paymentDetails = paymentDetails else {
            isDoneButtonEnable = false
            return
        }
        
        mainView.firstnameField.text = paymentDetails.firstName
        mainView.lastnameField.text = paymentDetails.lastName
        mainView.emailField.text = paymentDetails.email
        mainView.phoneField.text = paymentDetails.phone
        mainView.countryField.text = paymentDetails.address
        mainView.cityField.text = paymentDetails.city
        mainView.regionField.text = paymentDetails.state
        mainView.streetField.text = paymentDetails.state
        mainView.codeField.text = paymentDetails.pincode
        
        textFieldValueChanged()
    }
    
    @objc private func textFieldValueChanged() {
        guard let firstName = mainView.firstnameField.text, !firstName.isEmpty,
              let lastName = mainView.lastnameField.text, !lastName.isEmpty,
              let email = mainView.emailField.text, !email.isEmpty,
              let phone = mainView.phoneField.text, !phone.isEmpty,
              let country = mainView.countryField.text, !country.isEmpty,
              let city = mainView.cityField.text, !city.isEmpty,
              let region = mainView.regionField.text, !region.isEmpty,
              let street = mainView.streetField.text, !street.isEmpty,
              let index = mainView.codeField.text, !index.isEmpty else {
            
            isDoneButtonEnable = false
            
            return
        }
        
        isDoneButtonEnable = true
        let newPaymentDetails = PaymentDetailsModel(firstName: firstName, lastName: lastName, phone: phone, email: email, address: country, city: city, state: region, pincode: index)
        var storage = PaymentDetailsStorage()
        storage.paymentDetails = newPaymentDetails
        self.paymentDetails = newPaymentDetails
    }
    
    //MARK: - Actions
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        
        guard let paymentDetails = paymentDetails else { return }
        
        params["client_info"] = paymentDetails.dictionaryDescription
        //params["list_items"] = nil
        //params["which_bank"] = nil
        //params["shipping_type"] = nil
        //params["shipping_adress"] = nil
        //params["subtotal"] = nil
        
            
        Network.shared.request(url: .makePayment, method: .post, parameters: params) { [weak self] (response: Result<PaymentUrl, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let response):
                if let url = URL(string: response.url){
                    self.presentSafariVC(with: url)
                }
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            self.stopLoading()
        }
    }
    
}

struct PaymentUrl: Codable {
    let url: String
}
