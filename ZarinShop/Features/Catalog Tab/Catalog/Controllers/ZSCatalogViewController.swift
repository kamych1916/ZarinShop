//
//  ZSSearchViewController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 11/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSCatalogViewController: ZSBaseViewController {
    
    //MARK: - Private variables
    
    private var data: [ZSCategoriesModel] = []
    private let cellIdentifier = "CatalogTableViewCell"
    
    //MARK: - GUI variables
    
    private lazy var searchController: ZSGatalogSearchController = {
        var controller = ZSGatalogSearchController()
        controller.obscuresBackgroundDuringPresentation = false
       
        return controller
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainLightColor
        setupNavigationBar()
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCategories()
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
    
    private func setupNavigationBar() {
        navigationItem.title = "Каталог"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - Network
    
    private func loadCategories() {
        startLoading()
        Network.shared.request(
            url: .categories, method: .get)
        { [weak self] (response: Result<[ZSCategoriesModel], ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let models):
                self.data = models
                break
            case .failure(let error):
                self.alertError(message: error.getDescription())
                break
            }
            self.stopLoading()
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        let model = data[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "\(model.kol) шт."
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectedBackgroungView = UIView()
        selectedBackgroungView.backgroundColor = .selectionCellBG
        cell.selectedBackgroundView = selectedBackgroungView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.row]
        let controller = ZSSubcategoriesViewController(subcategories: model.subcategories, title: model.name)
        Interface.shared.pushVC(vc: controller)
    }
    
}

extension ZSCatalogViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            
        } else {
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        print(text)
    }
    
}
