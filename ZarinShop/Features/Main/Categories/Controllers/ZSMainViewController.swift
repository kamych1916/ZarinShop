//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSMainViewController: ZSBaseViewController {
    
    // MARK: - Private Variables
    
    private var data: [ZSCategoriesModel] = []
    
    // MARK: - GUI Variables
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 350
        tableView.estimatedRowHeight = 350
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZSMainTableViewCell.self,
                           forCellReuseIdentifier: ZSMainTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
         var refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
         return refreshControl
     }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.setupNavigationBar()
        self.makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadCategories()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadCategories() {
        self.loadingAlert()
        Network.shared.request(
            url: .categories, method: .get)
        { [weak self] (response: Result<[ZSCategoriesModel], ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(let models):
                    self.data = models
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Главная"
    }

    // MARK: - Actions
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        self.loadCategories()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSMainTableViewCell.identifier, for: indexPath)
        
        let model = self.data[indexPath.row]
        (cell as? ZSMainTableViewCell)?.initCell(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ZSSubcategoriesViewController(category: self.data[indexPath.row])
        Interface.shared.pushVC(vc: controller)
    }
    
}
