//
//  ZSGatalogSearchController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 30/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSGatalogSearchController: UISearchController, UISearchBarDelegate {
    
    //MARK: - Private variables
    
    private var products: [ZSProductModel] = []
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }

    //MARK: - GUI variables
    
    private lazy var collectionView: UICollectionView = {
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
        collectionView.register(
            ZSProductsCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSProductsCollectionViewCell.identifier)
        return collectionView
    }()

    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        searchBar.delegate = self
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        collectionView.setContentOffset(CGPoint(x: 0, y: -180), animated: true)
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Setters

    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    //MARK: - Network
    
    private func searchProducts(with text: String) {
        startLoading()
        Network.shared.request(
            url: .searchProducts, method: .get,
            isQueryString: true, parameters: ["poisk": text])
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchProducts(with: text)
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ZSGatalogSearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZSProductsCollectionViewCell.identifier, for: indexPath)
        let model = products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?.initCell(with: model)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ZSProductDetailViewController(product: products[indexPath.row])
        Interface.shared.pushVC(vc: controller)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemsAspect / 2, height: itemsAspect)
    }

}
