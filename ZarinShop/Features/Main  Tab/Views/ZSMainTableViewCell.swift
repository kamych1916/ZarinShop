//
//  ZSMainTableViewCell.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 29/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSMainTableViewCell: UITableViewCell {
    
    //MARK: - Public variables
    
    static let identifier = "ZSMainTableViewCell"
    
    //MARK: - Private variables
    
    private var products: [ZSProductModel] = []
    
    //MARK: - GUI variables
    
    lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        return view
    }()

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var itemsAspect = UIScreen.main.bounds.width - 20 - 20 - 10
        layout.itemSize = CGSize(width: itemsAspect / 2, height: itemsAspect)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ZSProductsCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSProductsCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    func initCell(_ model: MainCellModel) {
         
        self.products = model.products
        self.titleLabel.text = model.title
        
        collectionView.reloadData()
        
        setNeedsUpdateConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(16)
        }
        
        collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Setters
    
    private func setup() {
        backgroundColor = .white
        selectionStyle = .none
        
        addSubviews()
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ZSMainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZSProductsCollectionViewCell.identifier, for: indexPath)
        let model = products[indexPath.row]
        (cell as? ZSProductsCollectionViewCell)?.initCell(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ZSProductDetailViewController(product: products[indexPath.row])
        Interface.shared.pushVC(vc: controller)
    }
    
}
