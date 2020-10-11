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
//        tableView.estimatedRowHeight = 400
//        tableView.rowHeight = UITableView.automaticDimensionr
        tableView.rowHeight = 350
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZSMainTableViewCell.self,
                           forCellReuseIdentifier: ZSMainTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.isNeedMenuBarButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
        //self.loadCategories()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadCategories() {
        Network.shared.request(
            url: Path.categories, method: .get,
            success: { (data: ZSCategoriesModel) in
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSMainTableViewCell.reuseId, for: indexPath)
        
        let model = self.data[indexPath.row]
        let isLeftTitle = indexPath.row % 2 == 0 ? true : false
        let image = indexPath.row % 2 == 0 ? UIImage(named: "men") : UIImage(named: "women")
        
        (cell as? ZSMainTableViewCell)?
            .initCell(image: image, title: model, isLeftTitle: isLeftTitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ZSProductsViewController()
        self.pushVC(controller)
    }
    
}
