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
        return view.frame.height * 0.20
    }
    private var data: [CartItemModel] = []
    
    // MARK: - GUI Variables
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(ZSCartTableViewCell.self, forCellReuseIdentifier: ZSCartTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    lazy var backgroundTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Корзина пуста"
        label.textAlignment = .center
        label.isHidden = true
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var buyView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.mainLightColor.withAlphaComponent(0.7)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var totalLabel: UILabel = {
        var label = UILabel()
        label.text = "Итого"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .right
        label.textColor = .textDarkColor
        return label
    }()
    
    lazy var totalValueLabel: UILabel = {
        var label = UILabel()
        label.text = " "
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .right
        label.textColor = .textDarkColor
        return label
    }()
    
    lazy var buyButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .mainColor
        button.adjustsImageWhenHighlighted = true
        button.addTarget(self, action: #selector(buyButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        navigationItem.title = "Корзина"
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: buyView.frame.height, right: 0)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        
        backgroundTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        buyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(70)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().inset(20)
        }
        
        totalValueLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(20)
        }
        
        buyButton.snp.makeConstraints { (make) in
            make.top.equalTo(totalLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
    }
    
    // MARK: - Actions
    
    @objc private func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        loadCart()
    }
    
    
    @objc private func buyButtonTapped(_ sender: UIButton) {
        let checkoutVC = ZSCheckoutViewController()
        Interface.shared.pushVC(vc: checkoutVC)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(backgroundTitleLabel)
        view.addSubview(buyView)
        buyView.addSubview(totalLabel)
        buyView.addSubview(totalValueLabel)
        buyView.addSubview(buyButton)
    }
    
    // MARK: - Network
    
    private func loadCart() {
        startLoading()
        Network.shared.request(
            url: .getCartList, method: .get)
        { [weak self] (response: Result<CartModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                self.data = []
                self.data = model.items
            case .failure(let error):
                if error == .unauthorized {
                    self.alertSignin()
                } else {
                    self.alertError(message: error.getDescription())
                }
            }
            if self.data.count > 0 {
                self.backgroundTitleLabel.isHidden = true
            } else {
                self.backgroundTitleLabel.isHidden = false
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.culculateTotal()
            self.stopLoading()
        }
    }
    
    // MARK: - Helpers
    
    private func culculateTotal() {
        var total: Double = 0
        for i in data {
            total += i.price
        }
        totalValueLabel.text = "\(total) сум"
    }
    
    private func deleteItem(_ model: CartItemModel) {
        
        let alert = UIAlertController(title: "Удаление", message: "Удалить \(model.name) из корзины?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.startLoading()
            let params: [String: Any] = ["id": model.id, "size": model.size]
            Network.shared.delete(
                url: ZSURLPath.delproduct.rawValue,
                parameters: params) {
                self.stopLoading()
                self.loadCart()
            } feilure: { (error) in
                self.alertError(message: error.detail)
                self.stopLoading()
                self.loadCart()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateItem(_ model: CartItemModel) {
        print(model)
    }
    
}
//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSCartTableViewCell.reuseId, for: indexPath)
        let model = data[indexPath.row]
        (cell as? ZSCartTableViewCell)?.initCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(
                style: .normal, title:  "",
                handler: { [weak self] (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
                    guard let self = self else { return }
                    let model = self.data[indexPath.row]
                    self.deleteItem(model)
            })
            if let cgImage = UIImage(named: "trash")?.cgImage {
                deleteAction.image = ImageWithoutRender(
                    cgImage: cgImage, scale: 3, orientation: .up)
                deleteAction.backgroundColor = .groupTableViewBackground
            }
            let config = UISwipeActionsConfiguration(actions: [deleteAction])
            config.performsFirstActionWithFullSwipe = false
            return config
    }
    
}
