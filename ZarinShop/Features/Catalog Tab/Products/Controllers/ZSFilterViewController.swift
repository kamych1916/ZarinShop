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
            if !params.isEmpty {
                setupWithParams()
            } else {
                resetButtonTapped(resetButton)
            }
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
        let pan = UIPanGestureRecognizer(target: self, action: #selector(topViewPan))
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
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.text = "Диапозон цены"
        label.textAlignment = .left
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceValueLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.textDarkColor.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 15)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rangeSlider: RangeSlider = {
        var slider = RangeSlider()
        slider.sizeToFit()
        slider.maximumValue = 10_000_000
        slider.minimumValue = 1_000
        slider.trackHighlightTintColor = .textGoldColor
        slider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var colorsLabel: UILabel = {
        var label = UILabel()
        label.text = "Выберите цвет"
        label.textAlignment = .left
        
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
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
    
    lazy var sizeLabel: UILabel = {
        var label = UILabel()
        label.text = "Выберите размер"
        label.textAlignment = .left
        label.textColor = .textDarkColor
        label.font = .systemFont(ofSize: 17)
        label.isUserInteractionEnabled = false
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
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Сброс", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.backgroundColor = .mainLightColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = view.frame.origin
        }
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        topDarkIndicatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(3)
            make.width.equalTo(32)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        priceValueLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(priceLabel.snp.centerY)
        }
        rangeSlider.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            let width = UIScreen.main.bounds.width - 20 - 20
            make.size.equalTo(CGSize(width: width, height: 28))
        }
        colorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rangeSlider.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        colorsCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(colorsLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        sizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(colorsCollectionView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        sizesCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(sizeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(sizesCollectionView.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
        resetButton.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(sizesCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.size.equalTo(CGSize(width: 150, height: 40))
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(topView)
        topView.addSubview(topDarkIndicatorView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(priceValueLabel)
        view.addSubview(rangeSlider)
        view.addSubview(colorsLabel)
        view.addSubview(colorsCollectionView)
        view.addSubview(sizeLabel)
        view.addSubview(sizesCollectionView)
        view.addSubview(confirmButton)
        view.addSubview(resetButton)
    }
    
    private func setupWithParams() {
        guard let color = params["color"],
              let size = params["size"],
              let fromPrice = params["fromPrice"],
              let toPrice = params["toPrice"],
              let from = Double(fromPrice),
              let to = Double(toPrice) else { return }
        
        rangeSlider.lowerValue = from
        rangeSlider.upperValue = to
        priceValueLabel.text = "от \(Int(from)) до \(Int(to))"
        
        guard let colorsFindedIndex = colors.firstIndex(of: color) else { return }
        selectedColor = color
        colorsCollectionView.selectItem(
            at: IndexPath(row: colorsFindedIndex, section: 0),
            animated: true, scrollPosition: .centeredHorizontally)
        
        guard let sizesFindedIndex = sizes.firstIndex(of: size) else { return }
        selectedSize = color
        sizesCollectionView.selectItem(
            at: IndexPath(row: sizesFindedIndex, section: 0),
            animated: true, scrollPosition: .centeredHorizontally)
    }
    
    //MARK: - Actions
    
    @objc private func topViewPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0,
            let pointOrigin = pointOrigin else { return }
        view.frame.origin = CGPoint(x: 0, y: pointOrigin.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 300 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = pointOrigin
                }
            }
        }
    }
    
    @objc private func rangeSliderValueChanged(_ sender: RangeSlider) {
        let lower = String(format: "%0.0f", sender.lowerValue.rounded())
        let upper = String(format: "%0.0f", sender.upperValue.rounded())
        priceValueLabel.text = "от \(lower) до \(upper)"
    }
    
    @objc private func confirmButtonTapped(_ sender: UIButton) {
        let lower = String(format: "%0.0f", rangeSlider.lowerValue.rounded())
        let upper = String(format: "%0.0f", rangeSlider.upperValue.rounded())
        params = ["color": selectedColor, "size": selectedSize, "fromPrice": lower, "toPrice": upper]
        filterHandler?(params)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        
        rangeSlider.lowerValue = 1_000
        rangeSlider.upperValue = 10_000_000

        let lower = String(format: "%0.0f", rangeSlider.lowerValue.rounded())
        let upper = String(format: "%0.0f", rangeSlider.upperValue.rounded())
        priceValueLabel.text = "от \(lower) до \(upper)"
        
        guard let color = params["color"],
              let size = params["size"] else { return }
        
        guard let colorsFindedIndex = colors.firstIndex(of: color) else { return }
        selectedColor = ""
        colorsCollectionView.deselectItem(at: IndexPath(row: colorsFindedIndex, section: 0), animated: true)
        
        guard let sizesFindedIndex = sizes.firstIndex(of: size) else { return }
        selectedSize = ""
        sizesCollectionView.deselectItem(at: IndexPath(row: sizesFindedIndex, section: 0), animated: true)
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ZSFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === colorsCollectionView {
            return colors.count
        }
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === colorsCollectionView  {
            let cell = getColorsCollectionViewCell(at: indexPath)
            return cell
        }
        return getSizesCollectionViewCell(at: indexPath)
    }
    
    private func getColorsCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorsCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSColorsCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSColorsCollectionViewCell)?.initCell(hexColor: colors[indexPath.row])
        return cell
    }

    private func getSizesCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sizesCollectionView.dequeueReusableCell(
            withReuseIdentifier: ZSSizesCollectionViewCell.identifier, for: indexPath)
        (cell as? ZSSizesCollectionViewCell)?.initCell(size: sizes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if collectionView === colorsCollectionView  {
            selectedColor = colors[indexPath.row]
        } else {
            selectedSize = sizes[indexPath.row]
        }
    }

}
