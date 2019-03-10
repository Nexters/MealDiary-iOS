//
//  MainCardHeaderView.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class FilterView: UIView {
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    static let identifier = "FilterView"
    
    class func instanceFromNib() -> FilterView? {
        return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? FilterView
    }
    
    func setUp(frame: CGRect) {
        self.frame = frame
        filterLabel.frame = CGRect(x: 20, y: 0, width: 50, height: frame.height)
        filterButton.frame = CGRect(x: 20, y: 0, width: 100, height: frame.height)
    }
}
