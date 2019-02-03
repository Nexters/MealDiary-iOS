//
//  MainCardTableViewCell.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class DetailCardTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var card: Card?
    
    static let identifier = "DetailCardTableViewCell"
//    let underlineAttributes : [NSAttributedString.Key: Any] = [
//        NSAttributedString.Key.foregroundColor : UIColor.gray,
//        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func getHeight(for card: Card?, parentViewSize: CGSize) -> CGFloat {
        guard let card = card else { return 0 }
        let detailtextHeight = card.detailText.getHeight(withConstrainedWidth: parentViewSize.width - 40, size: 14)
        return 500 + (detailtextHeight * 1.4)
    }
    
    func setUp(with card: Card, parentViewSize: CGSize) {
        self.card = card
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        cardNumberLabel.clipsToBounds = true
        cardNumberLabel.layer.cornerRadius = 10
        cardNumberLabel.text = "1/" + card.photos.count.description
        pointLabel.text = card.point.description
        restaurantNameLabel.text = card.restaurantName
        detailLabel.text = card.detailText
        dateLabel.text = card.date
        var hashTag = ""
        card.hashtagList.forEach { hashTag += ("#" + $0 + " ") }
        hashTagLabel.text = hashTag
        
        let detailtextHeight = card.detailText.getHeight(withConstrainedWidth: parentViewSize.width - 40, size: 14)
        detailLabel.changeLineSpacing(5)
        detailLabel.frame = CGRect(x: 20, y: 440, width: parentViewSize.width - 40, height: detailtextHeight * 1.4)

        //        addressLabel.attributedText = NSAttributedString(string: addressLabel.text ?? "", attributes: underlineAttributes)
    }
}

extension DetailCardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = card?.photos[indexPath.item]
        return cell
    }
}

extension DetailCardTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
