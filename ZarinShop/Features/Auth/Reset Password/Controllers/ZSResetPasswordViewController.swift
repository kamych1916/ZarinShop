//
//  ZSResetPasswordViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSResetPasswordViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var dismissHandler: (() -> Void)?
    
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
        label.text = "Введите Вашу почут для восстановления пароля"
        return label
    }()
    
    private lazy var Email: UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.borderStyle = .none
        field.layer.cornerRadius = 20
        field.backgroundColor = AppColors.mainLightColor.color()
        field.textColor = AppColors.textDarkColor.color()
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftViewMode = .always
        field.placeholder = "Код"
        field.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var retryView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var retryLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = AppColors.textDarkColor.color()
        label.textAlignment = .center
        label.text = "Не пришел код?"
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Поврорить", for: .normal)
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
        self.Email.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.Email.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.sectionSize)
        }
        self.retryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.continueButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(50)
        }
        self.retryLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        self.retryButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.retryLabel.snp.right).offset(5)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.companyNameLabel)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.Email)
        self.view.addSubview(self.continueButton)
        self.view.addSubview(self.retryView)
        self.retryView.addSubview(self.retryLabel)
        self.retryView.addSubview(self.retryButton)
    }
    
    private func setupGestures() {
        self.continueButton.addTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)
        self.Email.addTarget(self, action: #selector(self.textFieldValueChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func continueButtonTapped() {
        guard let code = self.Email.text else { return }
        self.loadingAlert()
        Network.shared.request(
            url: Path.checkCode + code,
            method: .get, parameters: self.params,
            isQueryString: true,
            success: { [weak self] (response: ZSSignupResponseModel)in
                self?.dismiss(animated: true, completion: {
                    
                })
        }) { [weak self] (error, code) in
            self?.dismiss(animated: true, completion: {
                self?.alertError(message: error.detail)
            })
        }
    }
    
    @objc private func textFieldValueChanged(_ sender: UITextField) {
        guard let code = self.Email.text,
            !code.isEmpty,
        code.count >= 4 else {
            if self.isContinueButtonEnable {
                self.isContinueButtonEnable = false
            }
            return
        }
        
        self.params = ["email": self.email]
        self.isContinueButtonEnable = true
    }
    
}
