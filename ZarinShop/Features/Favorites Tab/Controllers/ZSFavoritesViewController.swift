//
//  ZSFavoritesViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/25/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSFavoritesViewController: ZSBaseViewController {

    // MARK: - Private Variables

    private var data: [String] = []
    
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .groupTableViewBackground
        navigationItem.title = "Избранные"
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func buyButtonTapped(_ sender: UIButton) {
        let checkoutVC = ZSCheckoutViewController()
        Interface.shared.pushVC(vc: checkoutVC)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    // MARK: - Helpers
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSCartTableViewCell.reuseId, for: indexPath)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
