//
//  ZSResetPasswordViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
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
        return CGSize(width: self.view.bounds.width / 1.2, height: 60)
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
    
    private lazy var emailField = CustomTextField(placeholder: "E-mail")
    
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
            target: self, action: #selector(self.dismissButtonTapped))
        button.tintColor = .textDarkColor
        return button
    }()
    
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        self.setupNavigationBar()
        self.addSubviews()
        self.makeConstraints()
        self.setupGestures()
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
        self.emailField.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.emailField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.companyNameLabel)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.continueButton)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = self.dismissButton
    }
    
    private func setupGestures() {
        self.continueButton.addTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)
        self.emailField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func continueButtonTapped() {
        self.loadingAlert()
        Network.shared.request(
            url: .resetPassword, method: .get,
            isQueryString: true, parameters: self.params)
        { [weak self] (response: Result<ZSSigninUserModel, ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(let model):
                    let codeVC = ZSResetPasswordCodeViewController()
                    codeVC.initController(email: model.email)
                    self.navigationController?.pushViewController(codeVC, animated: true)
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
            })
        }
    }
    
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let email = self.emailField.text,
            !email.isEmpty,
            email.count >= 4 else {
            if self.isContinueButtonEnable {
                self.isContinueButtonEnable = false
            }
            return
        }
        
        self.params = ["email": email]
        self.isContinueButtonEnable = true
    }
    
}
