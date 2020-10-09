//
//  Templates.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

/*class ZSProductsViewController: UIViewController {
    
    // MARK: - Private Variables
    
    private let categories: [String] = ["Полотенца", "Коврики для ванной", "Комплект", "Салфетки", "Кухонные шторы"]
    private var products: [ZSProductModel] = [
        ZSProductModel(name: "Product 1", price: 15.8797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 2", price: 25.7777, image: UIImage(named: "women")!),
        ZSProductModel(name: "Product 3", price: 35.2797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 4", price: 45.1797, image: UIImage(named: "women")!),
        ZSProductModel(name: "Product 5", price: 55.7797, image: UIImage(named: "men")!),
        ZSProductModel(name: "Product 6", price: 65.4797, image: UIImage(named: "women")!)]
    
    private var isSearching: Bool = false
    private var searchedProducts: [ZSProductModel] = []
    
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    // MARK: - GUI Variables

    private lazy var headerView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "Поиск"
        bar.tintColor = AppColors.mainColor.color()
        bar.autocapitalizationType = .none
        bar.autocorrectionType = .no
        bar.backgroundImage = UIImage()
        if #available(iOS 13, *) {
            bar.searchTextField.backgroundColor = .white
        }
        bar.layer.shadowOpacity = 0.2
        bar.layer.shadowOffset = CGSize(width: 0, height: 2)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowRadius = 3
        bar.layer.masksToBounds = false
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private lazy var sortView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.sortButtonTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sortLabel: UILabel = {
        var label = UILabel()
        label.text = "Сортировка"
        label.textAlignment = .center
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filterView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.filterButtonTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var filterLabel: UILabel = {
        var label = UILabel()
        label.text = "Фильтр"
        label.textAlignment = .center
        label.textColor = AppColors.textDarkColor.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSGategoriesCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSGategoriesCollectionViewCell.reuseId)
        return collectionView
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColors.mainLightColor.color()
        self.addSubviews()
        self.makeConstraints()
        self.setupNavigationBar()
        self.setSelectedFirstCell(for: self.categoriesCollectionView)
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.categoriesCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.height.equalTo(50)
        }
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.categoriesCollectionView.snp.bottom).offset(10)
        }
        self.searchBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.sortView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(10)
            make.top.equalTo(self.searchBar.snp.bottom).offset(10)
            make.width.equalTo((self.itemsAspect / 2) - 20)
            make.height.equalTo(self.itemsAspect / 6)
        }
        self.filterView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview().inset(10)
            make.width.equalTo((self.itemsAspect / 2) - 20)
            make.height.equalTo(self.itemsAspect / 6)
        }
        self.sortLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.filterLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.productsCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
            make.top.equalTo(self.headerView.snp.bottom)
        }
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonTapped() {
        UIView.animate(withDuration: 0.1) {
            self.sortView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.sortView.backgroundColor = .groupTableViewBackground
        }
        UIView.animate(withDuration: 0.4) {
            self.sortView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.sortView.backgroundColor = .white
        }
    }
    
    @objc private func filterButtonTapped() {
    
        UIView.animate(withDuration: 0.1) {
            self.filterView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.filterView.backgroundColor = .groupTableViewBackground
        }
        UIView.animate(withDuration: 0.4) {
            self.filterView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.filterView.backgroundColor = .white
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.categoriesCollectionView)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.productsCollectionView)
        self.headerView.addSubview(self.searchBar)
        self.headerView.addSubview(self.filterView)
        self.headerView.addSubview(self.sortView)
        self.filterView.addSubview(self.filterLabel)
        self.sortView.addSubview(self.sortLabel)
    }
    
    private func setupNavigationBar() {
    }
    
    private func setSelectedFirstCell(for collectionView: UICollectionView) {
        let firstCellIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstCellIndexPath, animated: false, scrollPosition: .init())
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ZSProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.categoriesCollectionView {
            return self.categories.count
        }
        if self.isSearching {
            return self.searchedProducts.count
        }
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.categoriesCollectionView  {
            let cell = self.getCategoriesCollectionViewCell(at: indexPath)
            return cell
        }
        return self.getProductsCollectionViewCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.categoriesCollectionView  {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            for i in 0..<self.products.count {
                self.products[i].name = self.categories[indexPath.row] + " \(i + 1)"
                self.products[i].price = Float.random(in: 10...100)
            }
            self.productsCollectionView.reloadData()
        }
    }
    
    private func getCategoriesCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.categoriesCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSGategoriesCollectionViewCell.reuseId, for: indexPath)
        (cell as? ZSGategoriesCollectionViewCell)?
            .initCell(title: self.categories[indexPath.row])
        return cell
    }

    private func getProductsCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productsCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSProductsCollectionViewCell.reuseId, for: indexPath)
        let model = self.isSearching ? self.searchedProducts[indexPath.row] : self.products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?
            .initCell(image: model.image, title: model.name, price: model.price)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.categoriesCollectionView  {
            let label = UILabel()
            label.text = self.categories[indexPath.row]
            let width = label.intrinsicContentSize.width + 10 + 10 + 10
            return CGSize(width: width, height: 45)
        }
        return CGSize(width: self.itemsAspect / 2, height: self.itemsAspect)
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
        self.productsCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.productsCollectionView.reloadData()
    }
    
}*/


/*self.titleLabel.snp.remakeConstraints { [weak self] (make) in
    guard let self = self else { return }
    make.top.equalToSuperview().inset(50)
    if self.isLeftTitle {
        make.right.equalToSuperview().inset(30)
        self.titleLabel.textAlignment = .right
    } else {
        make.left.equalToSuperview().offset(30)
        self.titleLabel.textAlignment = .left
    }
}*/
