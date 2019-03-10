//
//  View+Ext.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 3..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.2, offSet: CGSize, radius: CGFloat = 3, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
}

extension CALayer {
    func rotateY(degree: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, degree * .pi / 180, 0, 1, 0)
        self.transform = transform
    }
}
