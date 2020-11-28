//
//  ZSProductsMainView.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

final class ZSProductsMainView: UIView {
    
    var isHiddenCategories: Bool = false {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    private var itemsAspect: CGFloat {
        return UIScreen.main.bounds.width - 20 - 20 - 10
    }
    
    // MARK: - GUI Variables
    
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
            let height: CGFloat = self.isHiddenCategories ? 0 : 50
            make.height.equalTo(height)
        }
        self.productsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.categoriesCollectionView.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Setters

    private func addSubviews() {
        self.addSubview(self.productsCollectionView)
        self.addSubview(self.categoriesCollectionView)
    }
    
    func setHiddenCategories(_ value: Bool) {
        self.categoriesCollectionView.snp.remakeConstraints { (make) in
            make.height.equalTo(0)
        }
        
    }
    
}
