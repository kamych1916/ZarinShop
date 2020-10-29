//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
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
    private var currenUser: ZSSigninUserModel? {
        return UserDefaults.standard.getUser()
    }
    private let settings: [String] = [
        "Язык приложения",
        "Мои адреса и карты",
        "Помощь и связь",
        "Уведомления",
        "Сменить/восстановить пароль",
        "Выйти"]
    
    //MARK: - GUI variables
    
    private lazy var topContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = AppColors.mainLightColor.color()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "userprofile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Имя"
        label.textAlignment = .center
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var profileEmailLabel: UILabel = {
        var label = UILabel()
        label.text = "Почта"
        label.textAlignment = .center
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Войти в профиль", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.signinButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppColors.mainLightColor.color()
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableViewCellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var notificationsSwitch: UISwitch = {
        var switchh = UISwitch()
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isNeedMenuBarButton = true
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Личный кабинет"
        self.addSubviews()
        self.makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViewWithSingin()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.topContainerView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        self.profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        self.signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        self.profileNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        self.profileEmailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topContainerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
    @objc private func signinButtonTapped(_ sener: UIButton) {
        let authVC = ZSAuthorizationViewController()
        authVC.modalPresentationStyle = .fullScreen
        authVC.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        authVC.loginHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.setupViewWithSingin()
        }
        self.present(authVC, animated: true, completion: nil)
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.topContainerView)
        self.view.addSubview(self.tableView)
        self.topContainerView.addSubview(self.profileImageView)
        self.topContainerView.addSubview(self.profileNameLabel)
        self.topContainerView.addSubview(self.profileEmailLabel)
        self.topContainerView.addSubview(self.signInButton)
    }
    
    private func setupViewWithSingin() {
        if self.isSignin {
            self.signInButton.isHidden = true
            self.signInButton.isEnabled = false
            self.profileNameLabel.isHidden = false
            self.profileEmailLabel.isHidden = false
            if let user = self.currenUser {
                self.profileNameLabel.text = user.firstname + " " + user.lastname
                self.profileEmailLabel.text = user.email
            }
        } else {
            self.signInButton.isHidden = false
            self.signInButton.isEnabled = true
            self.profileNameLabel.isHidden = true
            self.profileEmailLabel.isHidden = true
        }
    }
    
    //MARK: - Helpers
    
    private func logoutUser() {
        let alert = UIAlertController(title: "Выход из профиля", message: "Вы уверены, что хотите выйти из профиля?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { [weak self] (action) in
            self?.loadingAlert()
            Network.shared.delete(
                url: ZSURLPath.logout) {
                UserDefaults.standard.setLogoutUser()
                self?.setupViewWithSingin()
                self?.dismiss(animated: true, completion: nil)
            } feilure: { (error) in
                self?.alertError(message: error.detail)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showResetPasswordScreeen() {
        let resetVC = ZSResetPasswordViewController()
        let navigVC = UINavigationController(rootViewController: resetVC)
        navigVC.modalPresentationStyle = .fullScreen
        navigVC.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigVC.navigationItem.backBarButtonItem?.tintColor = AppColors.mainColor.color()
        navigVC.navigationBar.shadowImage = UIImage()
        navigVC.navigationBar.isTranslucent = false
        resetVC.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        self.present(navigVC, animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: self.tableViewCellReuseIdentifier)
        
        cell.textLabel?.text = self.settings[indexPath.row]
        cell.textLabel?.textColor = AppColors.textDarkColor.color()
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = ""
        cell.tintColor = .lightGray
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "Русский"
            break
        case 3:
            cell.accessoryType = .none
            cell.accessoryView = self.notificationsSwitch
            break
        case 4:
            cell.accessoryType = .none
            break
        case 5:
            cell.accessoryType = .none
            cell.textLabel?.textColor = .systemRed
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        switch indexPath.row {
        case 0:
            let dropDown = DropDown()
            dropDown.backgroundColor = .white
            dropDown.anchorView = cell.detailTextLabel
            dropDown.dataSource = ["Русский", "Узбекский"]
            dropDown.show()
            dropDown.selectionAction = { (index: Int, item: String) in
                cell.detailTextLabel?.text = item
            }
            break
        case 1:
            if self.isSignin {
                self.alertError(message: "Сначала авторизуйтесь")
            } else {
                //show addresses and cards screen
            }
            break
        case 2:
            //some link
            break
        case 3:
            self.notificationsSwitch.setOn(!self.notificationsSwitch.isOn, animated: true)
            break
        case 4:
            self.showResetPasswordScreeen()
            break
        case 5:
            self.logoutUser()
            break
        default:
            break
        }
    }
    
}
