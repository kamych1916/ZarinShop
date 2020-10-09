//
//  UIPageViewController+Ex.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/9/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

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
