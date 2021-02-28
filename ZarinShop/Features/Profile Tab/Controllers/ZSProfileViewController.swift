//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit
import DropDown

class ZSProfileViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    private let tableViewCellReuseIdentifier = "SettingsTableViewCellReuseIdentifier"
    
    private var isSignin: Bool {
        return UserDefaults.standard.isSingin()
    }
    private var currentUser: ZSUser? {
        return UserDefaults.standard.getUser()
    }
    private let settings: [String] = [
        "Язык приложения",
        "Мои адреса",
        "Мои заказы",
        "Помощь и связь",
        "Сменить пароль",
        "Выйти"]
    
    //MARK: - GUI variables
    
    private lazy var topContainerView: UIView = {
        var view = UIView()
        return view
    }()

    private lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "userprofile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        var label = UILabel()
        label.text = " "
        label.textAlignment = .center
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()

    private lazy var profileEmailLabel: UILabel = {
        var label = UILabel()
        label.text = " "
        label.textAlignment = .center
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Войти в профиль", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellReuseIdentifier)
        return tableView
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Профиль"
        addSubviews()
        makeConstraints()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewWithSingin()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self, name: .registationIsSuccessfully, object: nil)
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(32)
        }
        
        profileNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        profileEmailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
    @objc private func signinButtonTapped(_ sener: UIButton) {
        let authVC = ZSAuthorizationViewController()
        authVC.modalPresentationStyle = .fullScreen
        authVC.loginHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.setupViewWithSingin()
        }
        present(authVC, animated: true, completion: nil)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(registrationIsSuccesfully),
            name: .registationIsSuccessfully, object: nil)
    }
    
    @objc private func registrationIsSuccesfully() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        //view.addSubview(topContainerView)
        view.addSubview(tableView)
        topContainerView.addSubview(profileImageView)
        topContainerView.addSubview(profileNameLabel)
        topContainerView.addSubview(profileEmailLabel)
        topContainerView.addSubview(signInButton)
    }
    
    private func setupViewWithSingin() {
        if isSignin {
            signInButton.isHidden = true
            signInButton.isEnabled = false
            profileNameLabel.isHidden = false
            profileEmailLabel.isHidden = false
            if let user = currentUser {
                profileNameLabel.text = user.firstname + " " + user.lastname
                profileEmailLabel.text = user.email
            }
        } else {
            signInButton.isHidden = false
            signInButton.isEnabled = true
            profileNameLabel.isHidden = true
            profileEmailLabel.isHidden = true
        }
    }
    
    //MARK: - Network
    
    private func loadUser() {
        startLoading()
        Network.shared.request(
            url: .isLogin, method: .get)
        { [weak self] (response: Result<ZSSigninUserModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                UserDefaults.standard.setSinginUser(model)
            case .failure(let error):
                self.alertError(message: error.localizedDescription)
            }
            self.setupViewWithSingin()
            self.stopLoading()
        }
    }
    
    private func logoutUser() {
        let alert = UIAlertController(
            title: "Выход из профиля",
            message: "Вы уверены, что хотите выйти из профиля?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Подтвердить",
            style: .default, handler: { [weak self] (action) in
                self?.startLoading()
                Network.shared.delete(
                    url: URLPath.logout.rawValue,
                    success: { [weak self] in
                        UserDefaults.standard.setLogoutUser()
                        self?.setupViewWithSingin()
                        self?.stopLoading()
                    },
                    feilure: { [weak self] (error) in
                        self?.alertError(message: error.detail)
                        self?.stopLoading()
                })
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showResetPasswordScreeen() {
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
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: tableViewCellReuseIdentifier)
        
        cell.textLabel?.text = settings[indexPath.row]
        cell.textLabel?.textColor = .textDarkColor
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = ""
        cell.tintColor = .lightGray
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        let selectedBackgroungView = UIView()
        selectedBackgroungView.backgroundColor = .selectionCellBG
        cell.selectedBackgroundView = selectedBackgroungView
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "Русский"
        case 5:
            cell.accessoryType = .none
            cell.textLabel?.textColor = .systemRed
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        switch indexPath.row {
        case 0:
            let dropDown = DropDown()
            dropDown.backgroundColor = .white
            dropDown.anchorView = cell.detailTextLabel
            dropDown.dataSource = ["Русский"]//, "Узбекский"]
            dropDown.show()
            dropDown.selectionAction = { (index: Int, item: String) in
                cell.detailTextLabel?.text = item
            }
        case 1:
            let addressVC = ZSAdressViewController()
            Interface.shared.pushVC(vc: addressVC)
        case 2:
            let ordersVC = ZSOrdersViewController()
            Interface.shared.pushVC(vc: ordersVC)
        case 3:
            let aboutUsVC = ZSAboutUsViewController()
            Interface.shared.pushVC(vc: aboutUsVC)
        case 4:
            showResetPasswordScreeen()
        case 5:
            logoutUser()
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = topContainerView
        view.frame = .zero
        return view
    }
    
}
