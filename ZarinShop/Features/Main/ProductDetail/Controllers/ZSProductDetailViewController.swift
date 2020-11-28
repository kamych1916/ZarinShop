//
//  ZSProductDetailViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

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
        view.firstItem.selectedColorHandler = { [weak self] id in
            self?.loadProduct(with: id)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addToCartButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .mainColor
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
        
        self.view.backgroundColor = .secondaryColor
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
        }
        self.addToCartButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.specificationView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageSlideshow)
        self.scrollView.addSubview(self.titleView)
        self.scrollView.addSubview(self.descriptionView)
        self.scrollView.addSubview(self.specificationView)
        self.scrollView.addSubview(self.addToCartButton)
    }
    
    private func setupWithProduct() {
        guard let product = self.product else { return }
        self.titleView.initView(name: product.name, price: "\(product.price) сум")
        self.descriptionView.initView(text: product.description)
        
        self.specificationView.initView(
            colors: product.link_color,
            sizes: product.size,
            model: .init(title: "Модель", description: "Adidas"),
            country: .init(title: "Страна", description: "Turkey"))
        self.specificationView.firstItem.setSelected(with: product.color)

            /*self.imageSlideshow.setImageInputs([
            ImageSource(image: UIImage(named: "defauldProduct")!),
            ImageSource(image: UIImage(named: "defauldProduct")!),
            ImageSource(image: UIImage(named: "defauldProduct")!)])*/
        self.loadImages()
    }
    
    // MARK: - Network
    
    private func loadProduct(with id: Int) {
        self.loadingAlert()
        Network.shared.request(
            urlStr: "items/\(id)", method: .get)
        { [weak self] (response: Result<ZSProductModel, ZSNetworkError>) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                switch response {
                case .success(let model):
                    self.product = model
                    break
                case .failure(let error):
                    self.alertError(message: error.getDescription())
                    break
                }
                self.setupWithProduct()
            })
        }
    }
    
    private func loadImages() {
        guard let product = self.product else { return }
        var images: [InputSource] = []
        let group = DispatchGroup()
        for imageURL in product.image {
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
            guard let product = self.product else { return }
            let parameters: [String: Any] = [
                "id": product.id,
                "size": self.specificationView.secondItem.selectedSize,
                "kol": 1]
            self.loadingAlert()
            Network.shared.request(
                url: .addToCart, method: .post,
                parameters: parameters)
            { [weak self] (response: Result<CartModel, ZSNetworkError>) in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    switch response {
                    case .success(_):
                        self.showSuccessAlert()
                        break
                    case .failure(let error):
                        self.alertError(message: error.getDescription())
                        break
                    }
                })
            }
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
        self.present(alert, animated: true, completion: nil)
    }
    
}
