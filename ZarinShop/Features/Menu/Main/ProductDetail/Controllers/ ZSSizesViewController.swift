//
//   ZSSizesViewController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSSizesViewController: UIViewController {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    var data: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    //MARK: - GUI variables
    
    private lazy var topView: UIView = {
        var view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.topViewPan))
        view.addGestureRecognizer(pan)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var topDarkIndicatorView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Выберите размер"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(ZSSizesTableViewCell.self, forCellReuseIdentifier: ZSSizesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.hasSetPointOrigin {
            self.hasSetPointOrigin = true
            self.pointOrigin = self.view.frame.origin
        }
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.topDarkIndicatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(3)
            make.width.equalTo(32)
            make.centerX.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.topView)
        self.topView.addSubview(self.topDarkIndicatorView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.titleLabel)
    }
    
    //MARK: - Actions
    
    @objc private func topViewPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        guard translation.y >= 0,
            let pointOrigin = self.pointOrigin else { return }
        self.view.frame.origin = CGPoint(x: 0, y: pointOrigin.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: self.view)
            if dragVelocity.y >= 300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ZSSizesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSSizesTableViewCell.identifier, for: indexPath)
        let model = self.data[indexPath.row]
        var size = ""
        if model == "M" {
            size = "Средний"
        } else if model == "S" {
            size = "Маленький"
        } else if model == "L" {
            size = "Большой"
        } else {
            size = "Экстра"
        }
        (cell as? ZSSizesTableViewCell)?.initCell(model, size)
        return cell
    }
    
}
