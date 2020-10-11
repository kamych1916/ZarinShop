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
    
    private let categories: [String] = ["Полотенца", "Коврики для ванной", "Комплект", "Салфетки", "Кухонные шторы"]
    private var products: [ZSProductModel] = [
        ZSProductModel(name: "Product Product Product 1", price: 15.8797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 2", price: 25.7777, image: UIImage(named: "women")!),
        ZSProductModel(name: "Product Product Product 3", price: 35.2797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product Product Product 4", price: 45.1797, image: UIImage(named: "women")!),
        ZSProductModel(name: "Product  Product Product Product5", price: 55.7797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 6", price: 65.4797, image: UIImage(named: "women")!)]
    
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColors.mainLightColor.color()
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
            for i in 0..<self.products.count {
                self.products[i].name = self.categories[indexPath.row] + " \(i + 1)"
                self.products[i].price = Float.random(in: 10...100)
            }
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
            .initCell(title: self.categories[indexPath.row])
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
            label.text = self.categories[indexPath.row]
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
