//
//  ZSProductDetailSpecificationColors.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 11/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSProductDetailSpecificationColors: UIView {

    //MARK: - Public variables
    
    var selectedColor: String = "F5F5F5"
    var colors: [String] = [] {
               didSet {
            self.collectionView.reloadData()
            if self.colors.count > 0 {
                self.selectedColor = self.colors[0]
                self.collectionView.selectItem(
                    at: IndexPath(row: 0, section: 0),
                    animated: true, scrollPosition: .left)
            }
        }
    }
    
    //MARK: - GUI variables
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Цвета"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = AppColors.textGoldColor.color()
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
        layout.itemSize = CGSize(width: 32, height: 32)
        
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSColorsCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSColorsCollectionViewCell.identifier)
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
    
    func initView(item: ZSSpecificationModel) {
        self.titleLabel.text = item.title
        
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

extension ZSProductDetailSpecificationColors: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZSColorsCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSColorsCollectionViewCell)?.initCell(hexColor: self.colors[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.selectedColor = self.colors[indexPath.row]
    }
    
}
