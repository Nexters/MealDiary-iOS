//
//  View+Ext.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 2..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setOrangeUnderLine(alpha: CGFloat = 0.6) {
        let width = self.intrinsicContentSize.width + 5.0
        let underlineView = CALayer()
        underlineView.backgroundColor = UIColor.primaryOrange.withAlphaComponent(alpha).cgColor
        
        guard let superView = self.superview else { return }
        
        superView.layer.addSublayer(underlineView)
        superView.bringSubviewToFront(self)
        
        underlineView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height / 2, width: width, height: self.frame.size.height / 2)
    }
    
    func changeLineSpacing(_ space: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
