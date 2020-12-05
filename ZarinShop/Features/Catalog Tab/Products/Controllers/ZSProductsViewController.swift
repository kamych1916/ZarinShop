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
    private var searchedProducts: [ZSProductModel] = []
    private var filterParams: [String: String] = ["color": "0000FF",
                                                  "fromPrice": "1000",
                                                  "toPrice": "100000"]
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    // MARK: - GUI Variables
    
    lazy var collectionView: UICollectionView = {
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
            forCellWithReuseIdentifier: ZSProductsCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var filterBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "filter"),
            style: .plain, target: self,
            action: #selector(filterButtonTapped))
        button.tintColor = .textDarkColor
        return button
    }()

    lazy var sortBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain, target: self,
            action: #selector(sortButtonTapped))
        button.tintColor = .textDarkColor
        return button
    }()
        
    // MARK: - Initialization
    
    convenience init(subcategory: ZSSubcategoriesModel) {
        self.init()
        
        self.controllerTitle = subcategory.name
        self.initId = subcategory.id
        self.categories = subcategory.subcategories
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        addSubviews()
        makeConstraints()
        loadProducts(with: initId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
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
        present(controller, animated: true, completion: nil)
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
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(collectionView)
        navigationItem.rightBarButtonItems = [sortBarButton, filterBarButton]
    }
    
    private func setSelectedFirstCell(for collectionView: UICollectionView) {
        let firstCellIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstCellIndexPath, animated: false, scrollPosition: .init())
    }
    
    private func setupNavigationBar() {
        navigationItem.title = self.controllerTitle
    }
    
    // MARK: - Network
    
    private func loadProducts(with id: String) {
        startLoading()
        Network.shared.request(
            urlStr: URLPath.productsByID.rawValue + id,
            method: .get)
        { [weak self] (response: Result<[ZSProductModel], ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let models):
                self.products = models
                self.collectionView.reloadData()
            case .failure(let error):
                self.alertError(message: error.getDescription())
            }
            self.stopLoading()
        }
    }
    
    // MARK: - Helpers
    
    private func sortProducts(_ selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            searchedProducts = products.sorted{ return $0.price > $1.price }
        case 1:
            searchedProducts = products.sorted{ return $0.price < $1.price }
        case 2:
            searchedProducts = products.sorted{ return $0.discount > $1.discount }
        case 3:
            searchedProducts = products.sorted{ return $0.discount < $1.discount }
        default:
            break
        }
        isSearching = true
        collectionView.reloadData()
    }
    
    private func filterProducts() {
        let params = self.filterParams
        guard let color = params["color"],
              let fromPrice = params["fromPrice"],
              let toPrice = params["toPrice"],
              let from = Double(fromPrice),
              let to = Double(toPrice) else {
            self.isSearching = false
            self.collectionView.reloadData()
            return
        }
        
        searchedProducts = products.filter({ (product) -> Bool in
            return product.color == color &&
                (product.price >= from && product.price <= to)
        })
        isSearching = true
        collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ZSProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearching {
            return searchedProducts.count
        }
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getProductsCollectionViewCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ZSProductDetailViewController(product: self.products[indexPath.row])
        Interface.shared.pushVC(vc: controller)
    }

    private func getProductsCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZSProductsCollectionViewCell.identifier, for: indexPath)
        let model = isSearching ? searchedProducts[indexPath.row] : products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?.initCell(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemsAspect / 2, height: self.itemsAspect)
    }

}

//MARK: - UISearchBarDelegate

extension ZSProductsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            collectionView.reloadData()
        } else {
            searchedProducts = products.filter({ (data: ZSProductModel) -> Bool in
                return data.name.lowercased().contains(searchText.lowercased())
            })
            isSearching = true
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        collectionView.reloadData()
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
