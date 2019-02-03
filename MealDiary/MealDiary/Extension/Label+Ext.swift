//
//  View+Ext.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 2..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

extension UILabel {
    func setOrangeUnderLineView(alpha: CGFloat = 0.6, yConst: CGFloat = 0) {
        let width = self.intrinsicContentSize.width + 1.0
        let underlineLayer = CAShapeLayer()
        underlineLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + (self.frame.height / 2) + 2 + yConst, width: width, height: self.frame.height / 2)
        underlineLayer.backgroundColor = UIColor.primaryOrange.withAlphaComponent(alpha).cgColor
        self.superview?.layer.addSublayer(underlineLayer)
        self.superview?.bringSubviewToFront(self)
    }
    
    func changeLineSpacing(_ space: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
