//
//  ZSAuthorizationViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAuthorizationViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var loginHandler: (() -> Void)?
    
    // MARK: - Private Variables
    
    private var params: [String: String] = [:]
    private var isLoginButtonEnable: Bool = false {
        willSet {
            if newValue {
                UIView.animate(withDuration: 0.3) {
                    self.loginButton.backgroundColor = .mainColor
                    self.loginButton.isEnabled = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.loginButton.backgroundColor = .mainLightColor
                    self.loginButton.isEnabled = false
                }
            }
        }
    }
    private var sectionSize: CGSize {
        return CGSize(width: view.bounds.width / 1.2, height: 60)
    }
    
    // MARK: - GUI Variables
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
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
        label.text = "Авторизация"
        return label
    }()
    
    private lazy var emailField = CustomTextField(placeholder: "E-mail")
    
    private lazy var passwordField: CustomTextField = {
        var field = CustomTextField(placeholder: "Пароль")
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .mainLightColor
        button.isEnabled = false
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registerView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var registerLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textDarkColor
        label.textAlignment = .center
        label.text = "Нет аккаунта?"
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Создайте", for: .normal)
        button.setTitleColor(.blueLink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resetView: UIView = {
           var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var resetLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textDarkColor
        label.textAlignment = .center
        label.text = "Забыли пороль?"
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Восстановить", for: .normal)
        button.setTitleColor(.blueLink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(named: "dismiss"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.tintColor = .textDarkColor
        return button
    }()
      
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        hideKeyboardWhenTappedAround()
        addSubviews()
        makeConstraints()
        setupGestures()
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self, name: .registationIsSuccessfully, object: nil)
    }
    
    // MARK: - Constraits
    
    private func makeConstraints() {
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(150)
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
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(sectionSize)
        }
        registerView.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        registerLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(registerLabel.snp.right).offset(5)
            make.top.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        resetView.snp.makeConstraints { (make) in
            make.top.equalTo(registerView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        resetLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        resetButton.snp.makeConstraints { (make) in
            make.left.equalTo(resetLabel.snp.right).offset(5)
            make.top.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(dismissButton)
        scrollView.addSubview(companyNameLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerView)
        scrollView.addSubview(resetView)
        registerView.addSubview(registerLabel)
        registerView.addSubview(registerButton)
        resetView.addSubview(resetLabel)
        resetView.addSubview(resetButton)
    }
    
    private func setupGestures() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        emailField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(registrationIsSuccesfully),
            name: .registationIsSuccessfully, object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func registerButtonTapped(_ sender: UIButton) {
        let registrVC = ZSRegistrationViewController()
        let navigVC = UINavigationController(rootViewController: registrVC)
        navigVC.modalPresentationStyle = .fullScreen
        navigVC.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigVC.navigationItem.backBarButtonItem?.tintColor = .mainColor
        navigVC.navigationBar.shadowImage = UIImage()
        navigVC.navigationBar.isTranslucent = false
        registrVC.registerHandler = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.loginHandler?()
            })
        }
        present(navigVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        startLoading()
        Network.shared.request(
            url: .signin, method: .post,
            parameters: params)
        { [weak self] (response: Result<ZSSigninUserModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                UserDefaults.standard.setSinginUser(model)
                self.loginHandler?()
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            self.stopLoading()
        }
    }
    
    @objc private func resetButtonTapped() {
        let resetVC = ZSResetPasswordViewController()
        let navigVC = UINavigationController(rootViewController: resetVC)
        navigVC.modalPresentationStyle = .fullScreen
        navigVC.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigVC.navigationItem.backBarButtonItem?.tintColor = .mainColor
        navigVC.navigationBar.shadowImage = UIImage()
        navigVC.navigationBar.isTranslucent = false
        present(navigVC, animated: true, completion: nil)

    }
    
    @objc private func registrationIsSuccesfully() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty,
            !password.isEmpty,
        password.count >= 6 else {
            if isLoginButtonEnable {
                isLoginButtonEnable = false
            }
            return
        }
        
        params = ["email": email,
                       "password": password]
        isLoginButtonEnable = true
    }
    
}
