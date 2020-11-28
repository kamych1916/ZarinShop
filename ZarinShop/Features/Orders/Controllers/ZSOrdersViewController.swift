//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class ZSOrdersViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var segmentedControl: BetterSegmentedControl = {
        var segment = BetterSegmentedControl()
        segment.segments = LabelSegment.segments(
            withTitles: ["Все", "В пути", "Доставлено"],
            normalFont: .systemFont(ofSize: 15),
            normalTextColor: .textDarkColor,
            selectedFont: .systemFont(ofSize: 15),
            selectedTextColor: .white)
        segment.clipsToBounds = true
        segment.layer.cornerRadius = 30
        segment.backgroundColor = .white
        segment.indicatorView.layer.cornerRadius = 30
        segment.indicatorView.backgroundColor = .mainColor
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZSOrdersTableViewCell.self,
                           forCellReuseIdentifier: ZSOrdersTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainLightColor
        self.navigationItem.title = "Мои заказы"
        self.addSubviews()
        self.makeConstraints()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.tableView)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSOrdersTableViewCell.identifier, for: indexPath)
        (cell as? ZSOrdersTableViewCell)?.initCell()
        return cell
    }
    
}