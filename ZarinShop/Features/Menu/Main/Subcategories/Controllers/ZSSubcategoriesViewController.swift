//
//  ZSSubcategoriesViewController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/20/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSubcategoriesViewController: ZSBaseViewController {
    
    // MARK: - Private Variables
    
    private var mainCategory: ZSCategoriesModel!
    private var categories: [ZSSubcategoriesModel]!

    // MARK: - GUI Variables
    
    private lazy var headerView: ZSSubcategoriesHeaderView = {
        var view = ZSSubcategoriesHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZSSubcategoriesTableViewCell.self,
                           forCellReuseIdentifier: ZSSubcategoriesTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Initialization
    
    convenience init(category: ZSCategoriesModel) {
        self.init()
        
        self.mainCategory = category
        self.categories = category.subcategories
    }
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.isNeedMenuBarButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.tableView)
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSSubcategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSSubcategoriesTableViewCell.identifier, for: indexPath)
        
        let model = self.categories[indexPath.row]
        (cell as? ZSSubcategoriesTableViewCell)?.initCell(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ZSProductsViewController(category: self.categories[indexPath.row])
        self.pushVC(controller)
    }
    
}
