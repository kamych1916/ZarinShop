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
        let images: [InputSource] = [ImageSource(image: UIImage(named: "men")!),
        ImageSource(image: UIImage(named: "women")!),
        ImageSource(image: UIImage(named: "men")!),
        ImageSource(image: UIImage(named: "women")!),
        ImageSource(image: UIImage(named: "women")!)]
        imageSlideshow.setImageInputs(images)
        imageSlideshow.contentScaleMode = .scaleAspectFill
        imageSlideshow.translatesAutoresizingMaskIntoConstraints = false
        return imageSlideshow
    }()
    
    private lazy var titleView: ZSProductDetailTitleView = {
        var view = ZSProductDetailTitleView()
        view.initView(name: "Product name", price: "25700 сум")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionView: ZSProductDetailDescriptionView = {
        var view = ZSProductDetailDescriptionView()
        view.initView(text: "Домашние халаты традиционно носятся дома, как правило поверх пижамы. Раньше пижама считалась нижним бельём, и было зазорным появиться в ней перед семьёй или гостями. Как правило, халат носится после сна, за завтраком, по дороге от спальни до ванной, в позднее вечернее время перед сном. В больших господских домах это имело большее значение, нежели в небольших квартирах.")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var specificationView: ZSProductDetailSpecificationView = {
        var view = ZSProductDetailSpecificationView()
        view.initView(
            items: [.init(title: "Модель", description: "Adidas"),
                    .init(title: "Цвет", description: "Красный"),
                    .init(title: "Страна", description: "Турция"),
                    .init(title: "Размер", description: "М")])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isNeedMenuBarButton = false
        
        self.view.backgroundColor = AppColors.secondaryColor.color()
        self.addSubviews()
        self.makeConstraints()
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
            make.height.equalTo(60)
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
    
    // MARK: - Actions
    
    @objc private func addToCartButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .cartValueChanged, object: nil)
    }
    
}
