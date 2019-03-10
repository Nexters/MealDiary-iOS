//
//  SearchTableViewCell.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 16..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    static let identifier = "SearchTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImage.clipsToBounds = true
        self.selectionStyle = .none
        foodImage.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUp(with card: ContentCard) {
        if let data = card.photos.first as? Data {
            foodImage.image = UIImage(data: data)
        }
        titleLabel.text = card.titleText
        distanceLabel.text = "km"
        var hashTag = ""
        card.hashTagList.forEach { hashTag += ("#" + $0 + " ") }
        hashTagLabel.text = hashTag
        restaurantNameLabel.text = card.restaurantName
        self.selectionStyle = .none
    }
}
