//
//  MainViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 29/11/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSMainViewController: ZSBaseViewController {

    //MARK: - Private variables
    
    private var data: [MainCellModel] = []
    
    //MARK: - GUI variables
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = 450
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ZSMainTableViewCell.self, forCellReuseIdentifier: ZSMainTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Главная"
        
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    // MARK: - Actions
    
    @objc private func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        loadData()
    }
    
    // MARK: - Network
    
    private func loadData() {
        let group = DispatchGroup()
        var data: [MainCellModel] = []
        
        startLoading()
        group.enter()
        Network.shared.request(
            url: .hitSales, method: .get)
        { [weak self] (response: Result<[ZSProductModel], ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let models):
                data.append(.init(title: "Хит продаж", products: models))
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            group.leave()
        }
        
        group.enter()
        Network.shared.request(
            url: .specialOffer, method: .get)
        { [weak self] (response: Result<[ZSProductModel], ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let models):
                data.append(.init(title: "Специальное предложение", products: models))
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if data.count > 0 {
                self.data = []
                if let hit = data.first(where: {$0.title == "Хит продаж" }),
                   let spec = data.first(where: {$0.title == "Специальное предложение" }) {
                    self.data.append(hit)
                    self.data.append(spec)
                } else {
                    self.data.append(contentsOf: data)
                }
            }
            self.stopLoading()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
}

extension ZSMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSMainTableViewCell.identifier, for: indexPath)
        let model = data[indexPath.row]
        (cell as? ZSMainTableViewCell)?.initCell(model)
        return cell
    }

}
