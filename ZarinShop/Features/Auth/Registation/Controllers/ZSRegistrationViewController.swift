//
//  ZSRegistrationViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSRegistrationViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var registerHandler: (() -> Void)?
    
    // MARK: - Private Variables
    
    private var params: [String: String] = [:]
    private var isRegisterButtonEnable: Bool = false {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.registerButton.backgroundColor = .mainColor
                    self.registerButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.registerButton.backgroundColor = .mainLightColor
                    self.registerButton.isEnabled = false
                }
            }
        }
    }
    
    private var sectionSize: CGSize {
        return CGSize(width: self.view.bounds.width / 1.2, height: 60)
    }
    
    // MARK: - GUI Variables
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
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
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .textDarkColor
        label.textAlignment = .center
        label.text = "Регистрация"
        return label
    }()
    
    private lazy var firstnameField = CustomTextField(placeholder: "Имя")
    
    private lazy var lastnameField = CustomTextField(placeholder: "Фамилия")
    
    private lazy var emailField: CustomTextField = {
        var field = CustomTextField(placeholder: "E-mail")
        field.keyboardType = .emailAddress
        return field
    }()
    
    private lazy var phoneField: CustomTextField = {
        var field = CustomTextField(placeholder: "Телефон")
        field.keyboardType = .phonePad
        return field
    }()
    
    private lazy var passwordField: CustomTextField = {
        var field = CustomTextField(placeholder: "Пароль")
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        return field
    }()
    
    private lazy var privacyLabel: UILabel = {
        var label = UILabel()
        let string = NSMutableAttributedString(string: "Продолжив Вы принимаете Пользовательское соглашение и Политику конфидециальности")
        string.setColorForText("Пользовательское соглашение", with: .blue)
        string.setColorForText("Политику конфидециальности", with: .blue)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.attributedText = string
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.privacyLabelTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.setTitle("Регистрация", for: .normal)
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
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
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
        self.firstnameField.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.lastnameField.snp.makeConstraints { (make) in
            make.top.equalTo(self.firstnameField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.phoneField.snp.makeConstraints { (make) in
            make.top.equalTo(self.lastnameField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.emailField.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(self.emailField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordField.snp.bottom).offset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.privacyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.registerButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.sectionSize.width)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(companyNameLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(firstnameField)
        scrollView.addSubview(lastnameField)
        scrollView.addSubview(phoneField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(privacyLabel)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = self.dismissButton
    }
    
    private func setupGestures() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        firstnameField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        lastnameField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let firstname = firstnameField.text,
            let lastname = lastnameField.text,
            let phone = phoneField.text,
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = passwordField.text,
            !firstname.isEmpty,
            !lastname.isEmpty,
            !phone.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
            
            if isRegisterButtonEnable {
                isRegisterButtonEnable = false
            }
            return
        }
        
        self.params = ["first_name": firstname,
                       "last_name": lastname,
                       "email": email,
                       "phone": phone,
                       "password": password]
        self.isRegisterButtonEnable = true
    }
    
    @objc private func registerButtonTapped() {
        startLoading()
        Network.shared.request(
            url: .signup, method: .post,
            parameters: params)
        { [weak self] (response: Result<ZSSignupUserModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                let codeVC = ZSRegistrationCodeViewController()
                codeVC.initController(email: model.email)
                self.navigationController?.pushViewController(codeVC, animated: true)
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            self.stopLoading()
        }
    }
    
    @IBAction func privacyLabelTapped(gesture: UITapGestureRecognizer) {
        guard let text = self.privacyLabel.text else { return }
        
        let termsRange = (text as NSString).range(of: "Пользовательское соглашение")
        let privacyRange = (text as NSString).range(of: "Политику конфидециальности")

        if gesture.didTapAttributedTextInLabel(label: self.privacyLabel, inRange: termsRange) {
            print("Пользовательское соглашение")
        } else if gesture.didTapAttributedTextInLabel(label: self.privacyLabel, inRange: privacyRange) {
            print("Политику конфидециальности")
        }
    }

}
