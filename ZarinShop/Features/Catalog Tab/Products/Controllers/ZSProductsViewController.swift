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
    
    private var controllerTitle: String = ""
    private var initId: String = ""
    private var categories: [ZSSubcategoriesModel] = []
    private var products: [ZSProductModel] = []
    private var isSearching: Bool = false
    private var isHiddenCategories: Bool = false
    private var searchedProducts: [ZSProductModel] = []
    private var filterParams: [String: String] =
        ["color": "0000FF", "fromPrice": "1000", "toPrice": "100000"]
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    // MARK: - GUI Variables
    
    private lazy var mainView: ZSProductsMainView = {
        var view = ZSProductsMainView()
        view.categoriesCollectionView.delegate = self
        view.categoriesCollectionView.dataSource = self
        view.productsCollectionView.delegate = self
        view.productsCollectionView.dataSource = self
        view.isHiddenCategories = self.isHiddenCategories
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    private lazy var filterBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "filter"),
            style: .plain, target: self,
            action: #selector(self.filterButtonTapped))
        button.tintColor = .mainColor
        return button
    }()

    private lazy var sortBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain, target: self,
            action: #selector(self.sortButtonTapped))
        button.tintColor = .mainColor
        return button
    }()
        
    // MARK: - Initialization
    
    convenience init(subcategory: ZSSubcategoriesModel) {
        self.init()
        
        self.controllerTitle = subcategory.name
        self.initId = subcategory.id
        self.categories = subcategory.subcategories
        self.isHiddenCategories = false
    }
    
    convenience init(category: ZSCategoriesModel) {
        self.init()
        
        self.controllerTitle = category.name
        self.initId = category.id
        self.categories = []
        self.isHiddenCategories = true
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainLightColor
        self.setupNavigationBar()
        self.addSubviews()
        self.makeConstraints()
        self.loadProducts(with: self.initId)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonTapped(_ button: UIBarButtonItem) {
        let controller = ZSSortViewController()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.selected = { [weak self] index in
            self?.sortProducts(index)
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc private func filterButtonTapped(_ button: UIBarButtonItem) {
        let controller = ZSFilterViewController()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.params = self.filterParams
        controller.filterHandler = { [weak self] params in
            self?.filterParams = params
            self?.filterProducts()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.mainView)
        self.navigationItem.rightBarButtonItems = [self.sortBarButton, self.filterBarButton]
    }
    
    private func setSelectedFirstCell(for collectionView: UICollectionView) {
        let firstCellIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstCellIndexPath, animated: false, scrollPosition: .init())
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = self.controllerTitle
    }
    
    // MARK: - Network
    
    private func loadProducts(with id: String) {
        self.loadingAlert()
        Network.shared.request(
            urlStr: URLPath.productsByID.rawValue + id,
            method: .get)
        { [weak self] (response: Result<[ZSProductModel], ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(let models):
                    self.products = models
                    self.mainView.productsCollectionView.reloadData()
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
            })
        }
    }
    
    // MARK: - Helpers
    
    private func sortProducts(_ selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            self.searchedProducts = self.products.sorted{ return $0.price > $1.price }
            break
        case 1:
            self.searchedProducts = self.products.sorted{ return $0.price < $1.price }
            break
        case 2:
            self.searchedProducts = self.products.sorted{ return $0.discount > $1.discount }
            break
        case 3:
            self.searchedProducts = self.products.sorted{ return $0.discount < $1.discount }
            break
        default:
            break
        }
        self.isSearching = true
        self.mainView.productsCollectionView.reloadData()
    }
    
    private func filterProducts() {
        let params = self.filterParams
        guard let color = params["color"],
              let fromPrice = params["fromPrice"],
              let toPrice = params["toPrice"],
              let from = Double(fromPrice),
              let to = Double(toPrice) else {
            self.isSearching = false
            self.mainView.productsCollectionView.reloadData()
            return
        }
        
        self.searchedProducts = self.products.filter({ (product) -> Bool in
            return product.color == color &&
                (product.price >= from && product.price <= to)
        })
        self.isSearching = true
        self.mainView.productsCollectionView.reloadData()
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
            let controller = ZSProductDetailViewController(product: self.products[indexPath.row])
            Interface.shared.pushVC(vc: controller)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.mainView.productsCollectionView.reloadData()
        } else {
            self.searchedProducts = self.products.filter({ (data: ZSProductModel) -> Bool in
                return data.name.lowercased().contains(searchText.lowercased())
            })
            self.isSearching = true
        }
        self.mainView.productsCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.mainView.productsCollectionView.reloadData()
    }
    
}


// MARK: - UIViewControllerTransitioningDelegate

extension ZSProductsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = BottomPresentationController(presentedViewController: presented, presenting: presenting)
        if presented is ZSFilterViewController {
            present.presentedViewFrame = CGRect(
                origin: CGPoint(x: 0, y: presented.view.frame.height - 450),
                size: CGSize(width: presented.view.frame.width, height: 450))
        } else if presented is ZSSortViewController {
            present.presentedViewFrame = CGRect(
                origin: CGPoint(x: 0, y: presented.view.frame.height - 300),
                size: CGSize(width: presented.view.frame.width, height: 300))
        }
        return present
    }
}
