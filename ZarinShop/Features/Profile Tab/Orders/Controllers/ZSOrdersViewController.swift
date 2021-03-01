//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class ZSOrdersViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    private var data: [ZSOrderItemModel] = []
    private var selectedSegment: ZSOrderState = .completed
    
    //MARK: - GUI variables
    
    private lazy var segmentedControl: BetterSegmentedControl = {
        var segment = BetterSegmentedControl()
        var titles: [String] = ZSOrderState.allCases.map({$0.localized})
        segment.segments = LabelSegment.segments(
            withTitles: titles,
            normalFont: .systemFont(ofSize: 15),
            normalTextColor: .textDarkColor,
            selectedFont: .systemFont(ofSize: 15),
            selectedTextColor: .white)
        segment.clipsToBounds = true
        segment.layer.cornerRadius = 30
        segment.backgroundColor = .white
        segment.indicatorView.layer.cornerRadius = 30
        segment.indicatorView.backgroundColor = .mainColor
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
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
        navigationItem.title = "Мои заказы"
        addSubviews()
        makeConstraints()
        loadOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
    }
    
    //MARK: - Actions
    
    @objc private func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        loadOrders()
    }
    
    @objc private func segmentChanged(sender: BetterSegmentedControl) {
        switch sender.index {
        case 0: selectedSegment = .completed
        case 1: selectedSegment = .awaiting
        case 2: selectedSegment = .canceled
        default: return
        }
        tableView.reloadData()
    }
    
    //MARK: - Helpers
    
    private func loadOrders() {
        startLoading()
        Network.shared.request(
            url: .getOrders, method: .get)
        { [weak self] (response: Result<[ZSOrderItemModel], ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let orders):
                self.data = []
                self.data = orders
            case .failure(let error):
                if error == .unauthorized {
                    self.alertSignin()
                } else {
                    self.alertError(message: error.getDescription())
                }
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.stopLoading()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.filter({
            $0.state.lowercased() ==
                self.selectedSegment.rawValue.lowercased()
        }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSOrdersTableViewCell.identifier, for: indexPath)
        let model = data
            .filter({$0.state.lowercased() == self.selectedSegment.rawValue.lowercased()
        })[indexPath.row]
        (cell as? ZSOrdersTableViewCell)?.initCell(with: model)
        return cell
    }
    
}
