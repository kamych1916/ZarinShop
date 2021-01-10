//
//  ZSProductDetailSpecificationSizes.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 11/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductDetailSpecificationSizes: UIView {

    //MARK: - Public variables
    
    var selectedSize: String = "S" {
        didSet {
            NotificationCenter.default.post(name: .productDetailSizeChanged, object: nil)
        }
    }
    var sizes: [String] = []
    
    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Цвета"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .textGoldColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: 36, height: 36)
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSSizesCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSSizesCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubviews()
    }
    
    func initView(sizes: [String]) {
        self.sizes = sizes
        self.collectionView.reloadData()
        if self.sizes.count > 0 {
            self.selectedSize = self.sizes[0]
            self.collectionView.selectItem(
                at: IndexPath(row: 0, section: 0),
                animated: true, scrollPosition: .left)
        }
        self.setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(20)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(132)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.collectionView)
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ZSProductDetailSpecificationSizes: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZSSizesCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSSizesCollectionViewCell)?.initCell(size: self.sizes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.selectedSize = self.sizes[indexPath.row]
    }

}
