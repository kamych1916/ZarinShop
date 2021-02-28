//
//  ZSResetPasswordCodeViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSResetPasswordCodeViewController: UIViewController {
    
    // MARK: - Private Variables
    
    private var params: [String: String] = [:]
    private var email: String = ""
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
        label.text = "Введите код подтверждения и Ваш новый пароль"
        return label
    }()
    
    private lazy var codeField = CustomTextField(placeholder: "Код")
    
    private lazy var newPasswordField: CustomTextField = {
        var field = CustomTextField(placeholder: "Новый пароль")
        field.isSecureTextEntry = true
        field.returnKeyType = .done
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
    
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        addSubviews()
        makeConstraints()
        setupGestures()
    }
    
    func initController(email: String) {
        self.email = email
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
        codeField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
        newPasswordField.snp.makeConstraints { (make) in
            make.top.equalTo(codeField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(newPasswordField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(companyNameLabel)
        view.addSubview(titleLabel)
        view.addSubview(codeField)
        view.addSubview(newPasswordField)
        view.addSubview(continueButton)
    }
    
    private func setupGestures() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        codeField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        newPasswordField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Helpers
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Поздравляем", message: "Вы успешно сменили пароль",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { (action) in
            NotificationCenter.default.post(name: .registationIsSuccessfully, object: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func retryButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func continueButtonTapped() {
        startLoading()
        Network.shared.request(
            url: .changePassword, method: .post,
            isQueryString: true,
            parameters: params)
        { [weak self] (response: Result<ZSSignupResponseModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.showSuccessAlert()
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            self.stopLoading()
        }
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let code = codeField.text,
            let password = newPasswordField.text,
            !code.isEmpty,
            password.count >= 6 else {
                if isContinueButtonEnable {
                    isContinueButtonEnable = false
                }
            return
        }
        
        params = ["email": email,
                       "code": code,
                       "new_password": password]
        isContinueButtonEnable = true
    }
    
}

