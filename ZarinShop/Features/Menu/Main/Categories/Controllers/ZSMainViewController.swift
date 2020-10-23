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
    
    private var data: [ZSCategoriesModel] = [
        .init(id: "1", name: "Halati", kol: 23, image_url: "some_url", subcategories: []),
        .init(id: "2", name: "Pizhami", kol: 44, image_url: "some_url", subcategories: []),
        .init(id: "3", name: "Drugoe", kol: 72, image_url: "some_url", subcategories: [])]
    
    // MARK: - GUI Variables
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 400
//        tableView.rowHeight = UITableView.automaticDimensionr
        tableView.rowHeight = 350
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZSMainTableViewCell.self,
                           forCellReuseIdentifier: ZSMainTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.isNeedMenuBarButton = true
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
            url: Path.categories, method: .get,
            success: { [weak self] (data: [ZSCategoriesModel]) in
                guard let self = self else { return }
                self.data = data
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }, feilure: { [weak self] (error, code) in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.alertError(message: error.detail)
                })
        })
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
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
        self.pushVC(controller)
    }
    
}
