//
//  UIView+Ex.swift
//  ZarinShop
//
//  Created by Humo Programmer  on 10/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundedCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(conteinerView: UIView? = nil, color: UIColor, opacity: Float = 1,
                    offSet: CGSize, radius: CGFloat = 1,
                    scale: Bool = true, bounds: CGRect? = nil) {
        if let conteinerView = conteinerView {
            conteinerView.clipsToBounds = false
            conteinerView.layer.shadowColor = color.cgColor
            conteinerView.layer.shadowOpacity = opacity
            conteinerView.layer.shadowOffset = offSet
            conteinerView.layer.shadowRadius = radius
            conteinerView.layer.shadowPath = UIBezierPath(
                roundedRect: conteinerView.bounds, cornerRadius: 20).cgPath
            
        } else {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offSet
            self.layer.shadowRadius = radius
            
            if let bounds = bounds {
                self.layer.shadowPath = UIBezierPath(
                    roundedRect: bounds,
                    cornerRadius: self.layer.cornerRadius).cgPath
            } else {
                self.layer.shadowPath = UIBezierPath(
                    roundedRect: self.bounds,
                    cornerRadius: self.layer.cornerRadius).cgPath
            }
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    }
    
}
