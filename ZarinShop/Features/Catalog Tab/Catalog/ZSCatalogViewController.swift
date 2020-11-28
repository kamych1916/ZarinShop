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
    
    private lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        
        var searchBar = controller.searchBar
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.tintColor = .black
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
        extendedLayoutIncludesOpaqueBars = true
        setupNavigationBar()
        addSubviews()
        makeConstraints()
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
        self.navigationItem.title = "Каталог"
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - Network
    
    private func loadCategories() {
        self.loadingAlert()
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
            self.dismiss(animated: true, completion: {
                self.tableView.reloadData()
            })
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
        let controller = ZSSubcategoriesViewController(category: data[indexPath.row])
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

/*class ZSSearchViewController: ZSBaseViewController, UISearchBarDelegate {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    private var products: [ZSProductModel] = [] {
        willSet {
            if newValue.count >= 1 {
                UIView.animate(withDuration: 0.1) {
                    self.backgroundView.alpha = 0
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.backgroundView.alpha = 1
                }
            }
        }
    }
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    //MARK: - GUI variables
    
    private lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        
        var searchBar = controller.searchBar
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.tintColor = .black
        return controller
    }()
    
    private lazy var backgroundView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundSearchImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "searchLoop")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var backgroundTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Поиск товаров по названию"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSProductsCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSProductsCollectionViewCell.reuseId)
        return collectionView
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainLightColor
        self.extendedLayoutIncludesOpaqueBars = true
        self.setupNavigationBar()
        self.addSubviews()
        self.makeConstraints()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.productsCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        self.backgroundView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.backgroundSearchImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(48)
        }
        self.backgroundTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.backgroundSearchImageView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.productsCollectionView)
        self.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.backgroundSearchImageView)
        self.backgroundView.addSubview(self.backgroundTitleLabel)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Поиск"
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - Network
    
    private func searchProducts(with text: String) {
        self.loadingAlert()
        Network.shared.request(
            url: .searchProducts, method: .get,
            isQueryString: true, parameters: ["poisk": text])
        { [weak self] (response: Result<[ZSProductModel], ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: {
                    switch response {
                    case .success(let models):
                        print("loaded")
                        self.products = models
                        self.productsCollectionView.reloadData()
                        break
                    case .failure(let error):
                        self.alertError(message: error.getDescription())
                        break
                    }
                })
            })
        }
    }
    
    //MARK: - Helpers
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            
        } else {
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchProducts(with: text)
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ZSSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZSProductsCollectionViewCell.reuseId, for: indexPath)
        let model = self.products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?.initCell(with: model)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ZSProductDetailViewController(product: self.products[indexPath.row])
        Interface.shared.pushVC(vc: controller)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemsAspect / 2, height: self.itemsAspect)
    }

}*/
