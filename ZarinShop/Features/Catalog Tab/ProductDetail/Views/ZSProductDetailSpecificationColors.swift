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
    
    var selectedColorHandler: ((Int) -> ())?
    var selectedColor: ZSLinkColorModel = ZSLinkColorModel(id: 1, color: "#FF00FF")
    var colors: [ZSLinkColorModel] = []
    
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
    
    func initView(colors: [ZSLinkColorModel]) {
        self.colors = colors
        collectionView.reloadData()
        
        setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        titleLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(20)
        }
        collectionView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(132)
        }
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    
    func setSelected(with color: String) {
        if let findedIndex = colors.firstIndex(where: { return $0.color == color }) {
            selectedColor = colors[findedIndex]
            collectionView.selectItem(
                at: IndexPath(row: findedIndex, section: 0),
                animated: true, scrollPosition: .left)
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ZSProductDetailSpecificationColors: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZSColorsCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSColorsCollectionViewCell)?.initCell(hexColor: colors[indexPath.row].color)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let model = colors[indexPath.row]
        selectedColor = model
        selectedColorHandler?(model.id)
    }
    
}
