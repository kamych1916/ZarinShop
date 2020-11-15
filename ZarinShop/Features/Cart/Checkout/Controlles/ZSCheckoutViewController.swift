//
//  ZSCheckoutViewController.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov on 10/10/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import ColorMatchTabs

class ZSCheckoutViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private let addressVC = ZSCheckoutAddressViewController()
    private let paymentVC = ZSCheckoutPaymentViewController()
    private let finalVC = ZSCheckoutFinalViewController()
    
    private lazy var controllers: [UIViewController] = {
        return [self.addressVC, self.paymentVC, self.finalVC]
    }()
    
    private lazy var topTabContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topTabBar: ColorTabs = {
        var view = ColorTabs()
        view.dataSource = self
        view.titleTextColor = .white
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.addTarget(self, action: #selector(self.topTabBarValueChanged), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.reloadData()
        return view
    }()
    
    private lazy var mainView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Заказ"
        self.view.backgroundColor = .groupTableViewBackground
        self.addSubviews()
        self.makeConstraints()
    }
    
    //MARK: - Constraints
    
    private func makeConstraints() {
        self.topTabContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(10)
            make.height.equalTo(80)
        }
        self.topTabBar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        self.mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topTabContainerView.snp.bottom)
            make.left.right.bottom.width.equalToSuperview()
        }
    }
    
    @objc private func topTabBarValueChanged(_ sender: ColorTabs) {
        let index = sender.selectedSegmentIndex
        let controller = self.controllers[index]
        controller.viewWillAppear(true)
        self.addChildToParent(controller, to: self.mainView)
    }
   
    func moveToNext() {
        let nextIndex = self.topTabBar.selectedSegmentIndex + 1
        if nextIndex < self.controllers.count {
            self.topTabBar.selectedSegmentIndex = nextIndex
            let controller = self.controllers[nextIndex]
            self.addChildToParent(controller, to: self.mainView)
        }
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.topTabContainerView)
        self.view.addSubview(self.mainView)
        self.topTabContainerView.addSubview(self.topTabBar)
        self.addChildToParent(self.addressVC, to: self.mainView)
    }
    
}

//MARK: - ColorTabsDataSource

extension ZSCheckoutViewController: ColorTabsDataSource {
    
    func numberOfItems(inTabSwitcher tabSwitcher: ColorTabs) -> Int {
        return ZSCheckoutTabItemsProvider.items.count
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, titleAt index: Int) -> String {
        return ZSCheckoutTabItemsProvider.items[index].title
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, iconAt index: Int) -> UIImage {
        return ZSCheckoutTabItemsProvider.items[index].normalImage
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, hightlightedIconAt index: Int) -> UIImage {
        return ZSCheckoutTabItemsProvider.items[index].highlightedImage
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, tintColorAt index: Int) -> UIColor {
        let selected = tabSwitcher.subviews[0]
        selected.layer.cornerRadius = 30
        let tmpFrame = selected.frame
        selected.frame = .init(x: tmpFrame.minX, y: tmpFrame.minY, width: tmpFrame.width, height: 60)
        return ZSCheckoutTabItemsProvider.items[index].tintColor
    }
    
}
