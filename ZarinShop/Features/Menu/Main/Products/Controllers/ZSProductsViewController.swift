//
//  ZSProductsViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/2/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SnapKit

class ZSProductsViewController: ZSBaseViewController {
    
    // MARK: - Private Variables
    
    private var mainCategory: ZSSubcategoriesModel!
    private var categories: [ZSSubcategoriesModel]!
    
    private var products: [ZSProductModel] = []
    
    private var isSearching: Bool = false
    private var searchedProducts: [ZSProductModel] = []
    
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    // MARK: - GUI Variables
    
    private lazy var mainView: ZSProductsMainView = {
        var view = ZSProductsMainView()
        view.searchBar.delegate = self
        view.categoriesCollectionView.delegate = self
        view.categoriesCollectionView.dataSource = self
        view.productsCollectionView.delegate = self
        view.productsCollectionView.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "My Custom Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    // MARK: - Initialization
    
    convenience init(category: ZSSubcategoriesModel) {
        self.init()
        
        self.mainCategory = category
        self.categories = category.subcategories
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColors.mainLightColor.color()
        self.setupNavigationBar()
        self.addSubviews()
        self.makeConstraints()
        self.loadProducts(with: self.mainCategory.id)
        self.addObservers()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonTapped(_ notification: Notification) {
        print("sort")
    }
    
    @objc private func filterButtonTapped(_ notification: Notification) {
        print("filter")
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.mainView)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.sortButtonTapped),
            name: .sortButtonTapped, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.filterButtonTapped),
            name: .filterButtonTapped, object: nil)
    }
    
    private func setSelectedFirstCell(for collectionView: UICollectionView) {
        let firstCellIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstCellIndexPath, animated: false, scrollPosition: .init())
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = self.mainCategory.name
    }
    
    // MARK: - Network
    
    private func loadProducts(with id: String) {
        self.loadingAlert()
        Network.shared.request(
            url: ZSURLPath.productsByID + id,
            method: .get) { [weak self] (products: [ZSProductModel]) in
            guard let self = self else { return }
            self.products = products
            self.mainView.productsCollectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        } feilure: { (error, code) in
            self.alertError(message: error.detail)
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ZSProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.mainView.categoriesCollectionView {
            return self.categories.count
        }
        if self.isSearching {
            return self.searchedProducts.count
        }
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.mainView.categoriesCollectionView  {
            let cell = self.getCategoriesCollectionViewCell(at: indexPath)
            return cell
        }
        return self.getProductsCollectionViewCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.mainView.categoriesCollectionView  {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.loadProducts(with: self.categories[indexPath.row].id)
        }  else {
            let controller = ZSProductDetailViewController()
            self.pushVC(controller)
        }
    }
    
    private func getCategoriesCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mainView.categoriesCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSGategoriesCollectionViewCell.reuseId, for: indexPath)
        (cell as? ZSGategoriesCollectionViewCell)?
            .initCell(title: self.categories[indexPath.row].name)
        return cell
    }

    private func getProductsCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mainView.productsCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSProductsCollectionViewCell.reuseId, for: indexPath)
        let model = self.isSearching ? self.searchedProducts[indexPath.row] : self.products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?.initCell(with: model)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.itemsAspect / 2, height: self.itemsAspect)
        if collectionView === self.mainView.categoriesCollectionView  {
            let label = UILabel()
            label.text = self.categories[indexPath.row].name
            let width = label.intrinsicContentSize.width + 10 + 10 + 10
            size = CGSize(width: width, height: 45)
        }
        return size
    }

}

//MARK: - UISearchBarDelegate

extension ZSProductsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchedProducts = self.products.filter({ (data: ZSProductModel) -> Bool in
            return data.name.lowercased().contains(text.lowercased())
        })
        self.isSearching = true
        self.mainView.productsCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.mainView.productsCollectionView.reloadData()
    }
    
}

/*class ZSProductsViewController: ZSBaseViewController {
    
    // MARK: - Private Variables
    
    private var mainCategory: ZSCategoriesModel!
    private var categories: [ZSSubcategoriesModel]!
    
    private var products: [ZSProductModel] = [
        ZSProductModel(name: "Product Product Product 1", price: 15.8797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 2", price: 25.7777, image: UIImage(named: "women")!),
        ZSProductModel(name: "Product Product Product 3", price: 35.2797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product Product Product 4", price: 45.1797, image: UIImage(named: "women")!),
        ZSProductModel(name: "Product  Product Product Product5", price: 55.7797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 6", price: 65.4797, image: UIImage(named: "women")!)]
    
    private var isSearching: Bool = false
    private var searchedProducts: [ZSProductModel] = []
    private var isNeedPopViewController: Bool = true
    
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    // MARK: - GUI Variables
    
    private lazy var mainView: ZSProductsMainView = {
        var view = ZSProductsMainView()
        view.searchBar.delegate = self
        view.categoriesCollectionView.delegate = self
        view.categoriesCollectionView.dataSource = self
        view.productsCollectionView.delegate = self
        view.productsCollectionView.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain, target: self,
            action: #selector(self.backBarButtonTapped))
        button.tintColor =  AppColors.mainColor.color()
        button.imageInsets = .init(top: 2, left: -8, bottom: 0, right: 0)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "My Custom Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    // MARK: - Initialization
    
    convenience init(category: ZSCategoriesModel) {
        self.init()
        
        self.mainCategory = category
        self.categories = category.subcategories
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColors.mainLightColor.color()
        self.setupNavigationBar()
        self.addSubviews()
        self.makeConstraints()
        self.addObservers()
        self.setSelectedFirstCell(
            for: self.mainView.categoriesCollectionView)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonTapped(_ notification: Notification) {
        print("sort")
    }
    
    @objc private func filterButtonTapped(_ notification: Notification) {
        print("filter")
    }
    
    @objc private func backBarButtonTapped(_ sender: UIBarButtonItem) {
        if self.isNeedPopViewController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.updateTitleLabel()
            self.isNeedPopViewController = true
            self.updateCategories()
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.mainView)
    }

    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        let titleLeftTitleView = UIBarButtonItem(customView: self.titleLabel)
        self.navigationItem.leftBarButtonItems = [self.backButton, titleLeftTitleView]
        self.updateTitleLabel()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.sortButtonTapped),
            name: .sortButtonTapped, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.filterButtonTapped),
            name: .filterButtonTapped, object: nil)
    }
    
    private func setSelectedFirstCell(for collectionView: UICollectionView) {
        let firstCellIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstCellIndexPath, animated: false, scrollPosition: .init())
    }
    
    // MARK: - Helpers
    
    private func updateTitleLabel(text: String? = nil) {
        guard let text = text else {
            self.titleLabel.text = self.mainCategory.name
            return
        }
        self.titleLabel.text = self.mainCategory.name + " / " + text
    }
    
    private func updateCategories() {
        if self.isNeedPopViewController {
            self.categories = self.mainCategory.subcategories
        } else {
            self.categories = self.mainCategory.subcategories[0].subcategories
        }
        self.mainView.categoriesCollectionView.reloadData()
    }
    
    private func updateProducts(with categoryId: String) {
        print(categoryId)
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ZSProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.mainView.categoriesCollectionView {
            return self.categories.count
        }
        if self.isSearching {
            return self.searchedProducts.count
        }
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.mainView.categoriesCollectionView  {
            let cell = self.getCategoriesCollectionViewCell(at: indexPath)
            return cell
        }
        return self.getProductsCollectionViewCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.mainView.categoriesCollectionView  {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            
            self.updateTitleLabel(text: self.categories[indexPath.row].name)
            self.isNeedPopViewController = false
            self.updateProducts(with: self.categories[indexPath.row].id)
            self.updateCategories()
            self.mainView.productsCollectionView.reloadData()
        }  else {
            let controller = ZSProductDetailViewController()
            self.pushVC(controller)
        }
    }
    
    private func getCategoriesCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mainView.categoriesCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSGategoriesCollectionViewCell.reuseId, for: indexPath)
        (cell as? ZSGategoriesCollectionViewCell)?
            .initCell(title: self.categories[indexPath.row].name)
        return cell
    }

    private func getProductsCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mainView.productsCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSProductsCollectionViewCell.reuseId, for: indexPath)
        let model = self.isSearching ? self.searchedProducts[indexPath.row] : self.products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?
            .initCell(image: model.image, title: model.name, price: model.price)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.itemsAspect / 2, height: self.itemsAspect)
        if collectionView === self.mainView.categoriesCollectionView  {
            let label = UILabel()
            label.text = self.categories[indexPath.row].name
            let width = label.intrinsicContentSize.width + 10 + 10 + 10
            size = CGSize(width: width, height: 45)
        }
        return size
    }

}

//MARK: - UISearchBarDelegate

extension ZSProductsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchedProducts = self.products.filter({ (data: ZSProductModel) -> Bool in
            return data.name.lowercased().contains(text.lowercased())
        })
        self.isSearching = true
        self.mainView.productsCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.mainView.productsCollectionView.reloadData()
    }
    
}*/
