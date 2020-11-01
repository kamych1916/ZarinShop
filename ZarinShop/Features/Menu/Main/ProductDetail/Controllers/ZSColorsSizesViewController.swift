//
//  ZSColorsSizesViewController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSColorsSizesViewController: UIViewController {
    
    //MARK: - Public variables
    
    var productId: String?
    var colors: [String] = [] {
        didSet {
            self.colorsCollectionView.reloadData()
        }
    }
    var sizes: [String] = [] {
        didSet {
            self.sizesCollectionView.reloadData()
        }
    }
    
    //MARK: - Private variables
    
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    //MARK: - GUI variables
    
    private lazy var topView: UIView = {
        var view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.topViewPan))
        view.addGestureRecognizer(pan)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var topDarkIndicatorView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel1: UILabel = {
        var label = UILabel()
        label.text = "Выберите цвет"
        label.textAlignment = .left
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var colorsCollectionView: UICollectionView = {
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
            ZSColorsCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSColorsCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var titleLabel2: UILabel = {
        var label = UILabel()
        label.text = "Выберите размер"
        label.textAlignment = .left
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sizesCollectionView: UICollectionView = {
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
            ZSSizesCollectionViewCell.self,
            forCellWithReuseIdentifier: ZSSizesCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var addToCartButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = AppColors.mainColor.color()
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(self.addToCartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.hasSetPointOrigin {
            self.hasSetPointOrigin = true
            self.pointOrigin = self.view.frame.origin
        }
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.topDarkIndicatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(3)
            make.width.equalTo(32)
            make.centerX.equalToSuperview()
        }
        
        self.titleLabel1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        self.colorsCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel1.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.titleLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(self.colorsCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.sizesCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel2.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.addToCartButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.topView)
        self.topView.addSubview(self.topDarkIndicatorView)
        self.view.addSubview(self.titleLabel1)
        self.view.addSubview(self.colorsCollectionView)
        self.view.addSubview(self.titleLabel2)
        self.view.addSubview(self.sizesCollectionView)
        self.view.addSubview(self.addToCartButton)
    }
    
    //MARK: - Actions
    
    @objc private func topViewPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        guard translation.y >= 0,
            let pointOrigin = self.pointOrigin else { return }
        self.view.frame.origin = CGPoint(x: 0, y: pointOrigin.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: self.view)
            if dragVelocity.y >= 300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    @objc private func addToCartButtonTapped(_ sender: UIButton) {
        guard let id = self.productId else { return }
        self.loadingAlert()
        let parameters: [String: Any] = ["id": id, "size": "XXL", "kol": 1]
        Network.shared.request(
            url: ZSURLPath.addToCart, method: .post, parameters: parameters,
            success: { [weak self] (data: CartModel) in
                self?.dismiss(animated: true, completion: nil)
        }, feilure: { [weak self] (error, code) in
            self?.dismiss(animated: true, completion: {
                self?.alertError(message: error.detail)
            })
        })
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ZSColorsSizesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.colorsCollectionView {
            return self.colors.count
        }
        return self.sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.colorsCollectionView  {
            let cell = self.getColorsCollectionViewCell(at: indexPath)
            return cell
        }
        return self.getSizesCollectionViewCell(at: indexPath)
    }
    
    private func getColorsCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.colorsCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSColorsCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSColorsCollectionViewCell)?.initCell(hexColor: self.colors[indexPath.row])
        return cell
    }

    private func getSizesCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.sizesCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSSizesCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSSizesCollectionViewCell)?.initCell(size: self.sizes[indexPath.row])
        return cell
    }

}
