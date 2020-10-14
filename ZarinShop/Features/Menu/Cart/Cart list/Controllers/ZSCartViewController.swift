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
    private var data: [String] = [
        "Халаты", "Пижамы",
        "Товары для ванной",
        "Товары для кухни",
        "Товары для спальни"]
    
    
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
        
        self.view.backgroundColor = .groupTableViewBackground
        super.isNeedMenuBarButton = true
        self.addSubviews()
        self.makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(self.buyViewHeight - 10)
        }
        self.buyView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.buyViewHeight)
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
            make.left.right.equalToSuperview().inset(20)
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
        let image = indexPath.row % 2 == 0 ? UIImage(named: "men") : UIImage(named: "women")
        
        (cell as? ZSCartTableViewCell)?
            .initCell(image: image, title: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ZSProductsViewController()
        self.pushVC(controller)
    }
    
}
