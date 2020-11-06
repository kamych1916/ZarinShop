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
    
    private lazy var buyView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = AppColors.mainLightColor.color()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deliveryLabel: UILabel = {
        var label = UILabel()
        label.text = "Доставка"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deliveryVulueLabel: UILabel = {
        var label = UILabel()
        label.text = "1000 сум"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        var label = UILabel()
        label.text = "Итого"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .right
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        var label = UILabel()
        label.text = "2100 сум"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .right
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = AppColors.mainColor.color()
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(self.buyButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isNeedMenuBarButton = true
        super.isNeedCartBarButton = false
        
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
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.buyView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        self.deliveryLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(20)
        }
        self.deliveryVulueLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(20)
        }
        self.totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        self.totalValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryVulueLabel.snp.bottom).offset(10)
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
        self.pushVC(checkoutVC)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.buyView)
        self.buyView.addSubview(self.deliveryLabel)
        self.buyView.addSubview(self.deliveryVulueLabel)
        self.buyView.addSubview(self.totalLabel)
        self.buyView.addSubview(self.totalValueLabel)
        self.buyView.addSubview(self.buyButton)
    }
    
    // MARK: - Network
    
    private func loadCart() {
        self.loadingAlert()
        Network.shared.request(
            url: ZSURLPath.getCartList, method: .get,
            success: { [weak self] (data: CartModel) in
                self?.dismiss(animated: true, completion: nil)
                self?.data = data.items
                self?.tableView.reloadData()
        }, feilure: { [weak self] (error, code) in
            self?.dismiss(animated: true, completion: {
                self?.alertError(message: error.detail)
            })
        })

    }
    
    // MARK: - Helpers
    
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
