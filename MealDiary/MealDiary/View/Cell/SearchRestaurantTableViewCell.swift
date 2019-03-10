//
//  SearchRestaurantTableViewCell.swift
//  MealDiary
//
//  Created by 박수현 on 22/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class SearchRestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    static let identifier = "SearchRestaurantTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
