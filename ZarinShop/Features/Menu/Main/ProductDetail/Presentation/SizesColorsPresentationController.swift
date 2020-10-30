//
//  SizesColorsPresentationController.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class SizesColorsPresentationController: UIPresentationController {

    //MARK: - GUI variables
    
    let blurEffectView: UIVisualEffectView!
    var tapGesture = UITapGestureRecognizer()
    
    //MARK: - Override properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.5),
               size: CGSize(width: self.containerView!.frame.width,
                            height: self.containerView!.frame.height * 0.5))
    }
    
    //MARK: - Initinalization
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissController))
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(self.tapGesture)
    }
    
    //MARK: - Override functions
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(self.blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.5
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.presentedView!.roundedCorners([.topLeft, .topRight], radius: 20)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.blurEffectView.frame = self.containerView!.bounds
    }

    //MARK: - Actions
    
    @objc private func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
