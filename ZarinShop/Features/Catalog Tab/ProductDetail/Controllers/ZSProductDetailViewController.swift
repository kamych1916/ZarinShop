//
//  ZSProductDetailViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/6/20.
//  Copyright © 2020 ZarinShop. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class ZSProductDetailViewController: ZSBaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    var selectedSize: String?
    var selectedCount: Int? {
        didSet {
            guard let selectedCount = selectedCount,
                  let selectedSize = selectedSize,
                  let product = product else { return }
            
        }
    }
    
    private var navBarDefaultImage: UIImage?
    private var navBarDefaultColor: UIColor?
    private var product: ZSProductModel?
    private var count: Int?
    
    // MARK: - GUI Variables
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset.bottom = 75
        return scroll
    }()
    
    lazy var imageSlideshow: ImageSlideshow = {
        var imageSlideshow = ImageSlideshow()
        imageSlideshow.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        let images: [InputSource] = []
        imageSlideshow.setImageInputs(images)
        imageSlideshow.contentScaleMode = .scaleAspectFill
        return imageSlideshow
    }()
    
    lazy var titleView: ZSProductDetailTitleView = {
        var view = ZSProductDetailTitleView()
        if let product = product,
           product.size_kol.count > 0,
           selectedCount == nil {
            view.stepperView.maxValue = product.size_kol[0].kol
            if let count = count,
               count <= product.size_kol[0].kol {
                view.stepperView.value = count
            }
        }
        return view
    }()
    
    lazy var descriptionView: ZSProductDetailDescriptionView = {
        var view = ZSProductDetailDescriptionView()
        return view
    }()

    lazy var specificationView: ZSProductDetailSpecificationView = {
        var view = ZSProductDetailSpecificationView()
        view.firstItem.selectedColorHandler = { [weak self] id in
            self?.loadProduct(with: id)
        }
        return view
    }()
    
    lazy var addToCartButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    convenience init(product: ZSProductModel, count: Int? = nil) {
        self.init()
        
        self.product = product
        self.count = count
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondaryColor
        addSubviews()
        makeConstraints()
        setupWithProduct()
        NotificationCenter.default.addObserver(self, selector: #selector(sizeChanged), name: .productDetailSizeChanged, object: nil)
    }
    
    @objc func sizeChanged() {
        let selectedSize = specificationView.secondItem.selectedSize
        guard let product = product,
              let foundedSize = product.size_kol.first(where: { (item) -> Bool in
            return item.size == selectedSize
              }) else { return }
        
        titleView.stepperView.maxValue = foundedSize.kol
        titleView.stepperView.value = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navBarDefaultImage = navigationController?.navigationBar.backgroundImage(for: .default)
        navBarDefaultColor = navigationController?.navigationBar.backgroundColor
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.setBackgroundImage(navBarDefaultImage, for: .default)
        navigationController?.navigationBar.backgroundColor = navBarDefaultColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imageSlideshow.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(imageSlideshow.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        specificationView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        addToCartButton.snp.makeConstraints { (make) in
            make.top.equalTo(specificationView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageSlideshow)
        scrollView.addSubview(titleView)
        scrollView.addSubview(descriptionView)
        scrollView.addSubview(specificationView)
        scrollView.addSubview(addToCartButton)
    }
    
    private func setupWithProduct() {
        guard let product = product else { return }
        titleView.initView(name: product.name,
                           price: "\(Int(product.price)) сум",
                           discaunt: "\(Int(product.discount)) сум")
        descriptionView.initView(text: product.description)
        
        var sizes: [String] = []
        for i in product.size_kol {
            sizes.append(i.size)
        }
        specificationView.initView(
            colors: product.link_color,
            sizes: sizes,
            model: .init(title: "Модель", description: "ZarinShop"),
            country: .init(title: "Страна", description: "Узбекистан"))
        specificationView.firstItem.setSelected(with: product.color)
        loadImages()
    }
    
    // MARK: - Network
    
    private func loadProduct(with id: Int) {
        startLoading()
        Network.shared.request(
            urlStr: "items/\(id)", method: .get)
        { [weak self] (response: Result<ZSProductModel, ZSNetworkError>) in
            guard let self = self else { return }
            switch response {
            case .success(let model):
                self.product = model
                break
            case .failure(let error):
                self.alertError(message: error.getDescription())
                break
            }
            self.setupWithProduct()
            self.stopLoading()
        }
    }
    
    private func loadImages() {
        guard let product = product else { return }
        var images: [InputSource] = []
        let group = DispatchGroup()
        for imageURL in product.images {
            group.enter()
            guard let imageURL = URL(string: imageURL) else {
                group.leave()
                return
            }
            KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                switch result {
                case .success(let value):
                    images.append(ImageSource(image: value.image))
                    break
                case .failure(_):
                    images.append(ImageSource(image: UIImage(named: "defauldProduct")!))
                    break
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard images.count > 0 else {
                guard let defaultImage = UIImage(named: "defauldProduct") else { return }
                images.append(ImageSource(image: defaultImage))
                self?.imageSlideshow.setImageInputs(images)
                return
            }
            self?.imageSlideshow.setImageInputs(images)
        }
    }
    
    // MARK: - Actions
    
    @objc private func addToCartButtonTapped(_ sender: UIButton) {
        if UserDefaults.standard.isSingin() {
            guard let product = product else { return }
            let parameters: [String: Any] = [
                "id": product.id,
                "size": specificationView.secondItem.selectedSize,
                "kol": titleView.stepperView.value]
            startLoading()
            Network.shared.request(
                url: .addToCart, method: .post,
                parameters: parameters)
            { [weak self] (response: Result<CartModel, ZSNetworkError>) in
                guard let self = self else { return }
                switch response {
                case .success(_):
                    self.showSuccessAlert()
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
                self.stopLoading()
            }
        } else {
            alertSignin()
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Поздравляем!",
            message: "Товар успешно добавлен в корзину.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отлично", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
