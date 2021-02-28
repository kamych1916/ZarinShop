//
//  ZSResetPasswordViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSResetPasswordViewController: UIViewController {
 
    // MARK: - Private Variables
    
    private var params: [String: String] = [:]
    private var isContinueButtonEnable: Bool = false {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.continueButton.backgroundColor = .mainColor
                    self.continueButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.continueButton.backgroundColor = .mainLightColor
                    self.continueButton.isEnabled = false
                }
            }
        }
    }
    
    private var sectionSize: CGSize {
        return CGSize(width: view.bounds.width / 1.2, height: 60)
    }
    
    // MARK: - GUI Variables
    
    private lazy var companyNameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.textColor = .textDarkColor
        label.textAlignment = .center
        label.text = "Zarin Shop"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .textDarkColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Введите Вашу почту для восстановления пароля"
        return label
    }()
    
    private lazy var emailField: CustomTextField = {
        var field = CustomTextField(placeholder: "E-mail")
        field.keyboardType = .emailAddress
        return field
    }()
    
    private lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .mainLightColor
        button.isEnabled = false
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dismissButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "dismiss"), style: .plain,
            target: self, action: #selector(dismissButtonTapped))
        button.tintColor = .textDarkColor
        return button
    }()
    
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
        addSubviews()
        makeConstraints()
        setupGestures()
    }
    
    // MARK: - Constraits
    
    private func makeConstraints() {
        companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(sectionSize.width)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(sectionSize.width)
        }
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(companyNameLabel)
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(continueButton)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func setupGestures() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        emailField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func continueButtonTapped() {
        startLoading()
        Network.shared.request(
            url: .resetPassword, method: .get,
            isQueryString: true, parameters: params)
        { [weak self] (response: Result<ZSSignupUserModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                let codeVC = ZSResetPasswordCodeViewController()
                codeVC.initController(email: model.email)
                self.navigationController?.pushViewController(codeVC, animated: true)
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            self.stopLoading()
        }
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !email.isEmpty,
            email.count >= 4 else {
            if isContinueButtonEnable {
                isContinueButtonEnable = false
            }
            return
        }
        
        params = ["email": email]
        isContinueButtonEnable = true
    }
    
}
