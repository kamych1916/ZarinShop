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
        return CGSize(width: self.view.bounds.width / 1.2, height: 60)
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
        button.addTarget(self, action: #selector(self.dismissButtonTapped), for: .touchUpInside)
        button.tintColor = .textDarkColor
        return button
    }()
      
    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        self.hideKeyboardWhenTappedAround()
        self.addSubviews()
        self.makeConstraints()
        self.setupGestures()
        self.addObservers()
    }
    
    // MARK: - Constraits
    
    private func makeConstraints() {
        self.dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(150)
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
        self.passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(self.emailField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.registerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        self.registerLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        self.registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.registerLabel.snp.right).offset(5)
            make.top.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.resetView.snp.makeConstraints { (make) in
            make.top.equalTo(self.registerView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        self.resetLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        self.resetButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.resetLabel.snp.right).offset(5)
            make.top.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.dismissButton)
        self.scrollView.addSubview(self.companyNameLabel)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.emailField)
        self.scrollView.addSubview(self.passwordField)
        self.scrollView.addSubview(self.loginButton)
        self.scrollView.addSubview(self.registerView)
        self.scrollView.addSubview(self.resetView)
        self.registerView.addSubview(self.registerLabel)
        self.registerView.addSubview(self.registerButton)
        self.resetView.addSubview(self.resetLabel)
        self.resetView.addSubview(self.resetButton)
    }
    
    private func setupGestures() {
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(self.registerButtonTapped), for: .touchUpInside)
        self.resetButton.addTarget(self, action: #selector(self.resetButtonTapped), for: .touchUpInside)
        self.emailField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
        self.passwordField.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.registrationIsSuccesfully),
            name: .registationIsSuccessfully, object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
        self.present(navigVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        self.loadingAlert()
        Network.shared.request(
            url: .signin, method: .post,
            parameters: self.params)
        { [weak self] (response: Result<ZSSigninUserModel, ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(let model):
                    UserDefaults.standard.setSinginUser(user: model)
                    self.loginHandler?()
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
            })
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
        self.present(navigVC, animated: true, completion: nil)

    }
    
    @objc private func registrationIsSuccesfully() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let email = self.emailField.text,
            let password = self.passwordField.text,
            !email.isEmpty,
            !password.isEmpty,
        password.count >= 6 else {
            if self.isLoginButtonEnable {
                self.isLoginButtonEnable = false
            }
            return
        }
        
        self.params = ["email": email,
                       "password": password]
        self.isLoginButtonEnable = true
    }
    
}