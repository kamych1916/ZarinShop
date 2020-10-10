//
//  ZSMainViewController.swift
//  ZaraShop
//
//  Created by Murad Ibrohimov on 10/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import ColorMatchTabs

class ZSOrdersViewController: ZSBaseViewController {
    
    //MARK: - Public variables
    
    //MARK: - Private variables
    
    //MARK: - GUI variables
    
    private lazy var controllers: [UIViewController] = {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .yellow
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .red
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        
        return [vc1, vc2, vc3]
    }()
    
    private lazy var topTabContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
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
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        super.isNeedMenuBarButton = true
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
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func topTabBarValueChanged(_ sender: ColorTabs) {
        let index = sender.selectedSegmentIndex
        let controller = self.controllers[index]
        controller.viewWillAppear(true)
        self.addChildToParent(controller, to: self.mainView)
    }
    
    //MARK: - Setters
    
    private func addSubviews() {
        self.view.addSubview(self.topTabContainerView)
        self.view.addSubview(self.mainView)
        self.topTabContainerView.addSubview(self.topTabBar)
    }
    
}

extension ZSOrdersViewController: ColorTabsDataSource {
    
    func numberOfItems(inTabSwitcher tabSwitcher: ColorTabs) -> Int {
        return TabItemsProvider.items.count
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, titleAt index: Int) -> String {
        return TabItemsProvider.items[index].title
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, iconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].normalImage
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, hightlightedIconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].highlightedImage
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, tintColorAt index: Int) -> UIColor {
        let selected = tabSwitcher.subviews[0]
        selected.layer.cornerRadius = 30
        let tmpFrame = selected.frame
        selected.frame = .init(x: tmpFrame.minX, y: tmpFrame.minY, width: tmpFrame.width, height: 60)
        return TabItemsProvider.items[index].tintColor
    }
    
}
