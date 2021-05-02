//
//  ResizableImageView.swift
//  ZarinShop
//
//  Created by Murodjon Ibrohimov on 2.05.21.
//  Copyright © 2021 Murad Ibrohimov. All rights reserved.
//

import UIKit

public class ResizableImageView: UIImageView {
    public override var intrinsicContentSize: CGSize {
        guard let image = image else { return .zero }
        let height = (image.size.height * frame.width) / image.size.width
        return CGSize(width: frame.width, height: height)
    }
}
