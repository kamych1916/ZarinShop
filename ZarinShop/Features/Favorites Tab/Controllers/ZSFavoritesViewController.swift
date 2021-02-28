//
//  ZSFavoritesViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/25/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSFavoritesViewController: ZSBaseViewController {

    // MARK: - Private Variables

    private var data: [ZSProductModel] = []
    
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
        tableView.register(ZSFavoriteTableCell.self,
                           forCellReuseIdentifier: ZSFavoriteTableCell.reuseId)
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
        label.text = "Нет избранных"
        label.textAlignment = .center
        label.isHidden = true
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        navigationItem.title = "Избранные"
        addSubviews()
        makeConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavorites()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backgroundTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(backgroundTitleLabel)
    }
    
    // MARK: - Helpers
    
    @objc private func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        loadFavorites()
    }
    
    private func loadFavorites() {
        startLoading()
        
        Network.shared.request(
            url: .getFavList, method: .get)
        { [weak self] (response: Result<[ZSProductModel], ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let items):
                self.data = []
                self.data = items
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
            self.stopLoading()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSFavoriteTableCell.reuseId, for: indexPath)
        let model = data[indexPath.row]
        (cell as? ZSFavoriteTableCell)?.initCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ZSProductDetailViewController(product: data[indexPath.row])
        Interface.shared.pushVC(vc: controller)
    }
    
}
