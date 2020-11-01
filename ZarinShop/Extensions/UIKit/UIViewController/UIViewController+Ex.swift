//
//  UIPageViewController+Ex.swift
//  ZarinShop
//
//  Created by Murad Ibrohimov  on 10/9/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

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
    
    func loadingAlert() {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        
        let waitText = "Подождите..."
        alert.message = waitText
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray

        alert.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        present(alert, animated: false, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            if self?.presentedViewController is UIAlertController {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
