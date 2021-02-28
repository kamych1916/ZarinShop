//
//  ZSSubcategoriesViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/20/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit

class ZSSubcategoriesViewController: ZSBaseViewController {
    
    // MARK: - Private Variables
    
    private var categories: [ZSSubcategoriesModel]!
    private var controllerTitle: String!
    private let cellIdentifier = "SubcategoriesTableViewCell"

    // MARK: - GUI Variables
    
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
    
    // MARK: - Initialization
    
    convenience init(subcategories: [ZSSubcategoriesModel], title: String) {
        self.init()
        
        self.categories = subcategories
        self.controllerTitle = title
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = controllerTitle
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSSubcategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        let model = categories[indexPath.row]
        cell.textLabel?.text = model.name
        cell.accessoryType = model.subcategories.count > 0 ? .disclosureIndicator : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectedBackgroungView = UIView()
        selectedBackgroungView.backgroundColor = .selectionCellBG
        cell.selectedBackgroundView = selectedBackgroungView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = categories[indexPath.row]
        let controller: UIViewController = model.subcategories.count > 0 ?
            ZSSubcategoriesViewController(subcategories: model.subcategories, title: model.name) :
            ZSProductsViewController(subcategory: model)
        Interface.shared.pushVC(vc: controller)
    }
    
}
