//
//  ZSFilterViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 11/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ZSFilterViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var filterHandler: (([String: String]) -> ())?
    var params: [String: String] = [:] {
        didSet {
            self.setupWithParams()
        }
    }
    
    // MARK: - Private Variables
    
    private var colors: [String] =
        ["#0000FF", "#008000", "#FF0000", "#000000", "#FFFFFF",
         "#C0C0C0", "#FFFF00", "#800080", "#FFA500", "#FFC0CB"]
    private var sizes: [String] = ["M", "L", "S", "XXL", "XS"]
    private var selectedColor: String = ""
    private var selectedSize: String = ""
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    // MARK: - GUI Variables
    
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
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Фильрт"
        label.textAlignment = .center
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.text = "Диапозон цены"
        label.textAlignment = .left
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceValueLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.textColor = AppColors.textDarkColor.color().withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 15)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rangeSlider: RangeSlider = {
        var slider = RangeSlider()
        slider.sizeToFit()
        slider.maximumValue = 100000
        slider.minimumValue = 1000
        slider.lowerValue = 1000
        slider.upperValue = 100000
        slider.trackHighlightTintColor = AppColors.textGoldColor.color()
        return slider
    }()
    
    private lazy var colorsLabel: UILabel = {
        var label = UILabel()
        label.text = "Выберите цвет"
        label.textAlignment = .left
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17)
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
        layout.itemSize = CGSize(width: 40, height: 40)
        
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
    
    lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.text = "Выберите размер"
        label.textAlignment = .left
        label.textColor = AppColors.textDarkColor.color()
        label.font = .systemFont(ofSize: 17)
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
        layout.itemSize = CGSize(width: 40, height: 40)
        
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
    
    private lazy var confirmButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Применить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.backgroundColor = AppColors.mainColor.color()
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(self.confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Сброс", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.backgroundColor = AppColors.mainLightColor.color()
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(self.resetButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
        self.rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !self.hasSetPointOrigin {
            self.hasSetPointOrigin = true
            self.pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Constraints
    
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
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview()
        }
        self.priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        self.priceValueLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.priceLabel.snp.centerY)
        }
        self.rangeSlider.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            let width = UIScreen.main.bounds.width - 20 - 20
            make.size.equalTo(CGSize(width: width, height: 28))
        }
        self.colorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.rangeSlider.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        self.colorsCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.colorsLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        self.sizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.colorsCollectionView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        self.sizesCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.sizeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.confirmButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.sizesCollectionView.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
        self.resetButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.sizesCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.topView)
        self.topView.addSubview(self.topDarkIndicatorView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.priceLabel)
        self.view.addSubview(self.priceValueLabel)
        self.view.addSubview(self.rangeSlider)
        self.view.addSubview(self.colorsLabel)
        self.view.addSubview(self.colorsCollectionView)
        self.view.addSubview(self.sizeLabel)
        self.view.addSubview(self.sizesCollectionView)
        self.view.addSubview(self.confirmButton)
        self.view.addSubview(self.resetButton)
    }
    
    private func setupWithParams() {
        guard let color = self.params["color"],
              let fromPrice = self.params["fromPrice"],
              let toPrice = self.params["toPrice"],
              let from = Double(fromPrice),
              let to = Double(toPrice) else { return }
        
        self.rangeSlider.lowerValue = from
        self.rangeSlider.upperValue = to
        self.priceValueLabel.text = "от \(from) до \(to)"
        
        guard let colorsFindedIndex = self.colors.firstIndex(of: color) else { return }
        self.selectedColor = color
        self.colorsCollectionView.selectItem(
            at: IndexPath(row: colorsFindedIndex, section: 0),
            animated: true, scrollPosition: .centeredHorizontally)
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
    
    @objc private func rangeSliderValueChanged(_ sender: RangeSlider) {
        let lower = String(format: "%0.0f", sender.lowerValue.rounded())
        let upper = String(format: "%0.0f", sender.upperValue.rounded())
        self.priceValueLabel.text = "от \(lower) до \(upper)"
    }
    
    @objc private func confirmButtonTapped(_ sender: UIButton) {
        let lower = String(format: "%0.0f", self.rangeSlider.lowerValue.rounded())
        let upper = String(format: "%0.0f", self.rangeSlider.upperValue.rounded())
        self.params = ["color": self.selectedColor, "fromPrice": lower, "toPrice": upper]
        self.filterHandler?(self.params)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        print("reset")
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ZSFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if collectionView === self.colorsCollectionView  {
            self.selectedColor = self.colors[indexPath.row]
        } else {
            self.selectedSize = self.sizes[indexPath.row]
        }
    }

}
