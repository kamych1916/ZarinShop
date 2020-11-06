//
//  ZSProductDetailViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import ImageSlideshow

class ZSProductDetailViewController: ZSBaseViewController {
    
    // MARK: - Public Variables
    
    // MARK: - Private Variables
    private var product: ZSProductModel?
    
    // MARK: - GUI Variables
    
    private lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var imageSlideshow: ImageSlideshow = {
        var imageSlideshow = ImageSlideshow()
        let images: [InputSource] = []
        imageSlideshow.setImageInputs(images)
        imageSlideshow.contentScaleMode = .scaleAspectFill
        imageSlideshow.translatesAutoresizingMaskIntoConstraints = false
        return imageSlideshow
    }()
    
    private lazy var titleView: ZSProductDetailTitleView = {
        var view = ZSProductDetailTitleView()
        view.initView(name: "Name", price: "0 сум")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionView: ZSProductDetailDescriptionView = {
        var view = ZSProductDetailDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var specificationView: ZSProductDetailSpecificationView = {
        var view = ZSProductDetailSpecificationView()
        view.initView(
            items: [.init(title: "Модель", description: "nil"),
                    .init(title: "Цвет", description: "nil"),
                    .init(title: "Размер", description: "nil"),
                    .init(title: "Страна", description: "nil")])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addToCartButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = AppColors.mainColor.color()
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(self.addToCartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    convenience init(product: ZSProductModel) {
        self.init()
        
        self.product = product
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isNeedMenuBarButton = false
        
        self.view.backgroundColor = AppColors.secondaryColor.color()
        self.addSubviews()
        self.makeConstraints()
        self.setupWithProduct()
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.imageSlideshow.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(self.view.bounds.width)
        }
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageSlideshow.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        self.specificationView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(90)
        }
        self.addToCartButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.addToCartButton)
        self.scrollView.addSubview(self.imageSlideshow)
        self.scrollView.addSubview(self.titleView)
        self.scrollView.addSubview(self.descriptionView)
        self.scrollView.addSubview(self.specificationView)
    }
    
    private func setupWithProduct() {
        guard let product = self.product else { return }
        self.titleView.initView(name: product.name, price: "\(product.price) сум")
        self.descriptionView.initView(text: product.description)
        var sizesString = ""
        for i in 0..<product.size.count {
            if i != 0 {
                sizesString.append("/" + product.size[i])
            } else if i == 0 {
                sizesString.append(product.size[i])
            }
        }
        self.specificationView.initView(
            items: [
                .init(title: "Цвет", description: "Red"),
                .init(title: "Размер", description: sizesString),
                .init(title: "Модель", description: "Adidas"),
                .init(title: "Страна", description: "Turkey")
        ])

        self.imageSlideshow.setImageInputs([
            ImageSource(image: UIImage(named: "defauldProduct")!),
            ImageSource(image: UIImage(named: "defauldProduct")!),
            ImageSource(image: UIImage(named: "defauldProduct")!)])
        //self.loadImages()
    }
    
    // MARK: - Helpers
    
    private func loadImages() {
        guard let product = self.product else { return }
        var images: [InputSource] = []
        let group = DispatchGroup()
        for imageURL in product.image {
            group.enter()
            let imageView = UIImageView()
            guard let imageURL = URL(string: (imageURL)) else {
                group.leave()
                return
            }
            imageView.kf.setImage(
                with: imageURL,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage],
                completionHandler:  { (result) in
                    guard let image = imageView.image else {
                        group.leave()
                        return
                    }
                    images.append(ImageSource(image: image))
                    group.leave()
                })
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
            guard let product = self.product else { return }
            self.loadingAlert()
            let parameters: [String: Any] = [
                "id": product.id,
                "size": self.specificationView.secondItem.selectedSize,
                "kol": 1]
            Network.shared.request(
                url: ZSURLPath.addToCart, method: .post, parameters: parameters,
                success: { [weak self] (data: CartModel) in
                    self?.dismiss(animated: true, completion: {
                        self?.showSuccessAlert()
                    })
            }, feilure: { [weak self] (error, code) in
                self?.dismiss(animated: true, completion: {
                    self?.alertError(message: error.detail)
                })
            })
        } else {
            self.alertSignin()
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Поздравляем!",
            message: "Товар успешно добавлен в корзину.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Скрыть", style: .cancel, handler: nil))
    }
    
}
