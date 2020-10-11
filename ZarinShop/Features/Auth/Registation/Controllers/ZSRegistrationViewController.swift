//
//  ZSRegistrationViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSRegistrationViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var dismissHandler: (() -> Void)?
    var registerHandler: (() -> Void)?
    
    // MARK: - Private Variables
    
    private var params: [String: String] = [:]
    private var isRegisterButtonEnable: Bool = false {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.registerButton.backgroundColor = AppColors.mainColor.color()
                    self.registerButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.registerButton.backgroundColor = AppColors.mainLightColor.color()
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
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .center
        label.text = "Zarin Shop"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .center
        label.text = "Регистрация"
        return label
    }()
    
    private lazy var firstnameField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = AppColors.mainLightColor.color()
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Имя"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var lastnameField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = AppColors.mainLightColor.color()
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Фамилия"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var emailField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = AppColors.mainLightColor.color()
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "E-mail"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        field.backgroundColor = AppColors.mainLightColor.color()
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Пароль"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var registerButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = AppColors.mainLightColor.color()
        button.isEnabled = false
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var loginLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .center
        label.text = "Есть аккаунт?"
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Авторизуйтесь", for: .normal)
        button.setTitleColor(AppColors.blueLink.color(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
            make.width.equalToSuperview().multipliedBy(1)
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
        self.emailField.snp.makeConstraints { (make) in
            make.top.equalTo(self.lastnameField.snp.bottom).offset(20)
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
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.loginView.snp.makeConstraints { (make) in
            make.top.equalTo(self.registerButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(50)
        }
        self.loginLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        self.loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.loginLabel.snp.right).offset(5)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.companyNameLabel)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.firstnameField)
        self.scrollView.addSubview(self.lastnameField)
        self.scrollView.addSubview(self.emailField)
        self.scrollView.addSubview(self.passwordField)
        self.scrollView.addSubview(self.registerButton)
        self.scrollView.addSubview(self.loginView)
        self.loginView.addSubview(self.loginLabel)
        self.loginView.addSubview(self.loginButton)
    }
    
    private func setupNavigationBar() {
    }
    
    private func setupGestures() {
        self.registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        self.firstnameField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
        self.lastnameField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
        self.emailField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
        self.passwordField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped(_ sender: UIBarButtonItem) {
        self.dismissHandler?()
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let firstname = self.firstnameField.text,
            let lastname = self.lastnameField.text,
            let email = self.emailField.text,
            let password = self.passwordField.text,
            !firstname.isEmpty,
            !lastname.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
        password.count >= 6 else {
            if self.isRegisterButtonEnable {
                self.isRegisterButtonEnable = false
            }
            return
        }
        
        self.params = ["first_name": firstname,
                       "last_name": lastname,
                       "email": email,
                       "password": password]
        self.isRegisterButtonEnable = true
        
    }
    
    @objc private func registerButtonTapped() {
        self.loadingAlert()
        Network.shared.request(
            url: Path.signup, method: .post,
            parameters: self.params,
            success: { [weak self] (data: ZSSignupUserModel) in
                self?.dismiss(animated: true, completion: {
                    let codeVC = ZSRegistrationCodeViewController()
                    codeVC.initController(email: data.email)
                    self?.navigationController?.pushViewController(codeVC, animated: true)
                })
        }) { [weak self] (error, code) in
            self?.dismiss(animated: true, completion: {
                self?.alertError(message: error.detail)
            })
        }
    }
    
    // MARK: - Helpers
    
}
