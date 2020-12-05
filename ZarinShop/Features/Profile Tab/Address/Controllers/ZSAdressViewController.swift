//
//  ZSAdressViewController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 04/12/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSAdressViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    var selectedAddressHandler: ((AddressModel) -> ())?
    
    //MARK: - Private variables
    
    private var isPresented: Bool = false
    private let cellIdentifier = "ZSAddressCell"
    private var data: [AddressModel] {
        AddressStorage().addresses
    }
    
    //MARK: - GUI variables
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        return tableView
    }()

    lazy var dismissButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "dismiss"), style: .plain,
            target: self, action: #selector(dismissButtonTapped))
        button.tintColor = .textDarkColor
        return button
    }()
    
    //MARK: - Init
    
    convenience init(isPresented: Bool) {
        self.init()
        
        self.isPresented = isPresented
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Мои адреса"
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
        if isPresented {
            navigationItem.leftBarButtonItem = dismissButton
        }
    }
    
    //MARK: - Actions
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func changeAddress(at index: Int) {
        let model = data[index]
        let addAddressVC = ZSAddAddressViewController(addressModel: model, index: index)
        addAddressVC.doneButtonHandler = { [weak self] in
            self?.tableView.reloadData()
        }
        present(addAddressVC, animated: true, completion: nil)
    }
    
    private func deleteAddress(at index: Int) {
        let alert = UIAlertController(title: "Удаление", message: "Удалить адрес?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            var storage = AddressStorage()
            storage.addresses.remove(at: index)
            self?.tableView.reloadData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension ZSAdressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let model = data[indexPath.row]
        
        cell.textLabel?.text = "\(model.country), \(model.city),"
        cell.detailTextLabel?.text = " \(model.district), ул. \(model.street) \(model.house), кв. \(model.apartment)"
        cell.detailTextLabel?.font = .systemFont(ofSize: 16)
        cell.detailTextLabel?.textColor = .lightGray
        
        cell.selectionStyle = .gray
        let selectedBackgroungView = UIView()
        selectedBackgroungView.backgroundColor = .selectionCellBG
        cell.selectedBackgroundView = selectedBackgroungView
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isPresented {
            selectedAddressHandler?(data[indexPath.row])
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.deleteAddress(at: indexPath.row)
            }))
            
            alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { _ in
                self.changeAddress(at: indexPath.row)
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}
