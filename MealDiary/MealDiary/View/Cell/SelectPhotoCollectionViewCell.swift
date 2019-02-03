//
//  SelectPhotoCollectionViewCell.swift
//  MealDiary
//
//  Created by mac on 2019. 1. 26..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import Photos

class SelectPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var checkedNumberLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var photo = PHAsset()
    var index: Int = 0
    
    static let identifier = "SelectPhotoCollectionViewCell"
    
    func setUp(with photo: PHAsset) {
        self.photo = photo
        imageView.fetchImage(asset: photo, contentMode: .aspectFill, targetSize: imageView.frame.size)
        checkedNumberLabel.clipsToBounds = true
        checkedNumberLabel.layer.cornerRadius = checkedNumberLabel.frame.size.width / 2
        
        if isSelected {
            checked(index: index)
        } else {
            unchecked()
        }
    }
    
    func checked(index: Int) {
        self.index = index
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.borderColor = UIColor.primaryOrange.cgColor
        view.layer.borderWidth = 3
        checkedNumberLabel.layer.borderWidth = 0
        checkedNumberLabel.backgroundColor = UIColor.primaryOrange
        checkedNumberLabel.text = (index).description
    }
    
    func unchecked() {
        view.layer.borderWidth = 0
        view.backgroundColor = .clear
        checkedNumberLabel.text = ""
        checkedNumberLabel.backgroundColor = .clear
        checkedNumberLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        checkedNumberLabel.layer.borderWidth = 2
    }
}
