//
//  ZSProductsMainView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

final class ZSProductsMainView: UIView {
    
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
    
    lazy var searchBar: UISearchBar = {
        var bar = UISearchBar()
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
    
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSGategoriesCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSGategoriesCollectionViewCell.reuseId)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSProductsCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSProductsCollectionViewCell.reuseId)
        return collectionView
    }()
    
    // MARK - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    
    // MARK: - Constraints

    override func updateConstraints() {
      
        self.categoriesCollectionView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.headerView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.categoriesCollectionView.snp.bottom).offset(10)
        }
        self.searchBar.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.sortView.snp.updateConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(10)
            make.top.equalTo(self.searchBar.snp.bottom).offset(10)
            make.width.equalTo((self.itemsAspect / 2) - 20)
            make.height.equalTo(self.itemsAspect / 6)
        }
        self.filterView.snp.updateConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview().inset(10)
            make.width.equalTo((self.itemsAspect / 2) - 20)
            make.height.equalTo(self.itemsAspect / 6)
        }
        self.sortLabel.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.filterLabel.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.productsCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(20)
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Setters

    private func addSubviews() {
        self.addSubview(self.categoriesCollectionView)
        self.addSubview(self.headerView)
        self.addSubview(self.productsCollectionView)
        self.headerView.addSubview(self.searchBar)
        self.headerView.addSubview(self.filterView)
        self.headerView.addSubview(self.sortView)
        self.filterView.addSubview(self.filterLabel)
        self.sortView.addSubview(self.sortLabel)
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
        NotificationCenter.default.post(name: .sortButtonTapped, object: nil)
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
        NotificationCenter.default.post(name: .filterButtonTapped, object: nil)
    }
}
