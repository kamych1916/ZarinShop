//
//  UIPageViewController+Ex.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/9/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SafariServices
import NVActivityIndicatorView


extension UIViewController {
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
}

//MARK: - Keyboard

extension UIViewController {
    
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK: - Add / remove child

extension UIViewController {
  
  func addChildToParent(_ controller: UIViewController, to containerView: UIView? = nil) {
      addChild(controller)
      if let containerView = containerView {
          controller.view.frame = containerView.bounds
          containerView.addSubview(controller.view)
      } else {
          controller.view.frame = view.bounds
          view.addSubview(controller.view)
      }
      controller.didMove(toParent: self)
  }
  
  func removeChildFromParent(_ controller: UIViewController) {
      controller.willMove(toParent: nil)
      controller.view.removeFromSuperview()
      controller.removeFromParent()
  }
    
}

// MARK: - Alerts

extension UIViewController {
    
    func alertError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Скрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func alertSignin() {
        let alert = UIAlertController(
            title: "Ошибка", message: "Чтобы продолжить, нужно автризоваться", preferredStyle: .alert)
        alert.addAction(.init(title: "Скрыть", style: .cancel, handler: nil))
        alert.addAction(.init(title: "Авторизация", style: .default, handler: { [weak self] (_) in
            let controller = ZSAuthorizationViewController()
            controller.modalPresentationStyle = .fullScreen
            controller.loginHandler = { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            self?.present(controller, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        view.addSubview(activityInticator)
        activityInticator.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        activityInticator.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            activityInticator.stopAnimating()
            activityInticator.snp.removeConstraints()
            activityInticator.removeFromSuperview()
        }
        
    }
    
}

let activityInticator: NVActivityIndicatorView = {
    var view = NVActivityIndicatorView(
        frame: .zero, type: .ballSpinFadeLoader,
        color: .gray, padding: 0)
    return view
}()

