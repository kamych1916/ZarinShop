//
//  ZSAddAddressViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/18/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAddAddressViewController: UIViewController {
    
    //MARK: - Public variables
    
    var doneButtonHandler: (() -> Void)?
    var addressModel: AddressModel?
    var index: Int?
    
    //MARK: - Private variables
    
    private var sectionSize: CGSize {
        return CGSize(width: view.bounds.width / 1.2, height: 60)
    }
    
    //MARK: - GUI variables
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Добавить новый адрес"
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var mainView: ZSAddAddressView = {
        var view = ZSAddAddressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dismissButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "dismiss"), style: .plain,
            target: self, action: #selector(dismissButtonTapped))
        button.tintColor = .textDarkColor
        return button
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
    
    convenience init(addressModel: AddressModel, index: Int) {
        self.init()
        
        self.addressModel = addressModel
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        hideKeyboardWhenTappedAround()
        addSubviews()
        makeConstraints()
        if let address = addressModel {
            setupWith(address)
        }
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        mainView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
            make.width.equalTo(view.frame.width - 40)
        }
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(mainView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        view.addSubview(doneButton)
        scrollView.addSubview(mainView)
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func setupWith(_ address: AddressModel) {
        mainView.countryField.text = address.country
        mainView.cityField.text = address.city
        mainView.regionField.text = address.district
        mainView.streetField.text = address.street
        mainView.houseField.text = address.house
        mainView.apartmentField.text = address.apartment
        mainView.codeField.text = address.index
    }
    
    //MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        guard let country = mainView.countryField.text,
              let city = mainView.cityField.text,
              let district = mainView.regionField.text,
              let street = mainView.streetField.text,
              let house = mainView.houseField.text,
              let apartment = mainView.apartmentField.text,
              let index = mainView.codeField.text else { return }
        
        let address = AddressModel(
            country: country, city: city,
            district: district, street: street,
            house: house, apartment: apartment, index: index)
        var storage = AddressStorage()
        
        if addressModel != nil,
           let index = self.index {
            //update
            storage.addresses[index] = address
        } else {
            //add new
            storage.addresses.append(address)
        }
        
        dismiss(animated: true, completion: nil)
        doneButtonHandler?()
    }
    
}
