//
//  ZSWebViewController.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 21.02.2021.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import UIKit
import WebKit

class ZSWebViewController: UIViewController, WKNavigationDelegate {
    
    lazy var webView = WKWebView()
    lazy var doneButton: UIBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .done,
                        target: self,
                        action: #selector(doneButtonTapped))
    lazy var reloadButton: UIBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .refresh,
                        target: self,
                        action: #selector(reloadButtonTapped))
    
    var url: URL
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        view = webView
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = reloadButton
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.title = String(url.relativeString.prefix(22)) + "..."
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func doneButtonTapped() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func reloadButtonTapped() {
        webView.reload()
    }
    
}

