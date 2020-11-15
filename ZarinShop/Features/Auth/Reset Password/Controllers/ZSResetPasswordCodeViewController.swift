//
//  ZSResetPasswordCodeViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
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
                    self.continueButton.backgroundColor = AppColors.mainColor.color()
                    self.continueButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.continueButton.backgroundColor = AppColors.mainLightColor.color()
                    self.continueButton.isEnabled = false
                }
            }
        }
    }
    
    private var sectionSize: CGSize {
        return CGSize(width: self.view.bounds.width / 1.2, height: 60)
    }
    
    // MARK: - GUI Variables
    
    private lazy var companyNameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .center
        label.text = "Zarin Shop"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppColors.textDarkColor.color()
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
        button.backgroundColor = AppColors.mainLightColor.color()
        button.isEnabled = false
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        self.addSubviews()
        self.makeConstraints()
        self.setupGestures()
    }
    
    func initController(email: String) {
        self.email = email
    }
    
    // MARK: - Constraits
    
    private func makeConstraints() {
        self.companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.sectionSize.width)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.companyNameLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.sectionSize.width)
        }
        self.codeField.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.newPasswordField.snp.makeConstraints { (make) in
            make.top.equalTo(self.codeField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.newPasswordField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.companyNameLabel)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.codeField)
        self.view.addSubview(self.newPasswordField)
        self.view.addSubview(self.continueButton)
    }
    
    private func setupGestures() {
        self.continueButton.addTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)
        self.codeField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
        self.newPasswordField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Helpers
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Поздравляем", message: "Вы успешно сменили пароль",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { (action) in
            NotificationCenter.default.post(name: .registationIsSuccessfully, object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func retryButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func continueButtonTapped() {
        self.loadingAlert()
        Network.shared.request(
            url: .changePassword, method: .post,
            isQueryString: true,
            parameters: self.params)
        { [weak self] (response: Result<ZSSignupResponseModel, ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(_):
                    self.showSuccessAlert()
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
            })
        }
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let code = self.codeField.text,
            let password = self.newPasswordField.text,
            !code.isEmpty,
            password.count >= 6 else {
                if self.isContinueButtonEnable {
                    self.isContinueButtonEnable = false
                }
            return
        }
        
        self.params = ["email": self.email,
                       "code": code,
                       "new_password": password]
        self.isContinueButtonEnable = true
    }
    
}

