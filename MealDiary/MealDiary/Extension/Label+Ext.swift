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
        let width = self.intrinsicContentSize.width + 1.0
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor.primaryOrange.withAlphaComponent(alpha)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superView = self.superview else { return }
        
        superView.addSubview(underlineView)
        superView.bringSubviewToFront(self)
        
        underlineView.topAnchor.constraint(equalTo: superView.safeTopAnchor, constant: self.frame.origin.y + (self.frame.height / 2) - 18).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: self.frame.origin.x).isActive = true
        underlineView.widthAnchor.constraint(equalToConstant: width).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
    }
    
    func changeLineSpacing(_ space: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
