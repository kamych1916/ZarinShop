//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCartViewController: ZSBaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    
    private var buyViewHeight: CGFloat {
        return self.view.frame.height * 0.20
    }
    private var data: [CartItemModel] = []
    
    // MARK: - GUI Variables
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZSCartTableViewCell.self,
                           forCellReuseIdentifier: ZSCartTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var backgroundView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundSearchImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "cart")?.with(color: .black)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var backgroundTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Корзина предметов"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buyView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .mainLightColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        var label = UILabel()
        label.text = "Итого"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .right
        label.textColor = .textDarkColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        var label = UILabel()
        label.text = "2100 сум"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .right
        label.textColor = .textDarkColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .mainColor
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(self.buyButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .groupTableViewBackground
        self.navigationItem.title = "Корзина"
        self.addSubviews()
        self.makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadCart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: self.buyView.frame.height, right: 0)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.backgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(-60)
        }
        self.backgroundSearchImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(48)
        }
        self.backgroundTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.backgroundSearchImageView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.buyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(70)
        }
        self.totalLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().inset(20)
        }
        self.totalValueLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(20)
        }
        self.buyButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    
    @objc private func buyButtonTapped(_ sender: UIButton) {
        let checkoutVC = ZSCheckoutViewController()
        Interface.shared.pushVC(vc: checkoutVC)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.backgroundSearchImageView)
        self.backgroundView.addSubview(self.backgroundTitleLabel)
        self.view.addSubview(self.buyView)
        self.buyView.addSubview(self.totalLabel)
        self.buyView.addSubview(self.totalValueLabel)
        self.buyView.addSubview(self.buyButton)
    }
    
    // MARK: - Network
    
    private func loadCart() {
        self.loadingAlert()
        Network.shared.request(
            url: .getCartList, method: .get)
        { [weak self] (response: Result<CartModel, ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(let model):
                    self.data = model.items
                    self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                    if model.items.count <= 0 {
                        self.setVisibleBackgroundView(true, with: "Корзина предметов пуста")
                    } else {
                        self.setVisibleBackgroundView(false, with: " ")
                    }
                    break
                case .failure(let error):
                    if error == .unauthorized {
                        self.setVisibleBackgroundView(true, with: "Для начала авторизуйтесь")
                        self.alertSignin()
                    } else {
                        self.setVisibleBackgroundView(true, with: "Что-то пошло не так")
                        self.alertError(message: error.getDescription())
                    }
                    
                    break
                }
            })
        }
    }
    
    // MARK: - Helpers
    
    private func setVisibleBackgroundView(_ value: Bool, with title: String) {
        if value {
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 1
                self.backgroundTitleLabel.text = title
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.backgroundView.alpha = 0
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSCartTableViewCell.reuseId, for: indexPath)
        let model = self.data[indexPath.row]
        (cell as? ZSCartTableViewCell)?.initCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(
                style: .normal, title:  "",
                handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
                    print("delete item")
            })
            if let cgImage = UIImage(named: "trash")?.cgImage {
                deleteAction.image = ImageWithoutRender(
                    cgImage: cgImage, scale: 2, orientation: .up)
                deleteAction.backgroundColor = .groupTableViewBackground
            }
            let config = UISwipeActionsConfiguration(actions: [deleteAction])
            config.performsFirstActionWithFullSwipe = false
            return config
    }
    
}
