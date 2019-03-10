//
//  RateCollectionViewCell.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 4..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

class RateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateNumLabel: UILabel!
    @IBOutlet weak var rateTextLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    
    static let identifier = "RateCollectionViewCell"
    
    func setUp(with rate: RateCard) {
        imageView.setGifImage(rate.rateImage)
        rateNumLabel.text = rate.rateNum.description + "점"
        rateTextLabel.text = rate.rateText
        cardView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 1), scale: true)
    }
}
