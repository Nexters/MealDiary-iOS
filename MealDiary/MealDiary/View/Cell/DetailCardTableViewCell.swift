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
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restaurantLocation: UILabel!
    @IBOutlet weak var locationView: UIView!
    
    var card: ContentCard?
    
    static let identifier = "DetailCardTableViewCell"
//    let underlineAttributes : [NSAttributedString.Key: Any] = [
//        NSAttributedString.Key.foregroundColor : UIColor.gray,
//        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func getHeight(for card: ContentCard?, parentViewSize: CGSize) -> CGFloat {
        guard let card = card else { return 0 }
        let detailtextHeight = card.detailText.getHeight(withConstrainedWidth: parentViewSize.width - 40, size: 14)
        return 500 + (detailtextHeight * 1.4)
    }
    
    func setUp(with card: ContentCard, parentViewSize: CGSize) {
        self.card = card
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        cardNumberLabel.clipsToBounds = true
        cardNumberLabel.layer.cornerRadius = 10
        cardNumberLabel.text = "1/" + card.photos.count.description
        pointLabel.text = card.score.description
        titleTextLabel.text = card.titleText
        detailLabel.text = card.detailText
        dateLabel.text = card.date.toString()
        var hashTag = ""
        card.hashTagList.forEach { hashTag += ($0 + " ") }
        hashTagLabel.text = hashTag
        
        let detailtextHeight = card.detailText.getHeight(withConstrainedWidth: parentViewSize.width - 40, size: 14)
        detailLabel.changeLineSpacing(5)
        detailLabel.frame = CGRect(x: 20, y: 450, width: parentViewSize.width - 40, height: detailtextHeight * 1.4)

        locationView.layer.cornerRadius = 4
        restaurantLabel.text = card.restaurantName
        restaurantLocation.attributedText = NSAttributedString(string: card.restaurantLocation, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        if card.restaurantName == "" {
            restaurantLabel.text = "식당 정보가 없습니다."
        }
    }
    
    var currentPage = 1
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1) + 1
        currentPage = page
        cardNumberLabel.text = currentPage.description + "/" + (card?.photos.count.description ?? "1")
    }
}

extension DetailCardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        if let photo = card?.photos[indexPath.item] {
            let asset = AssetManager.fetchImages(by: [photo.identifier]).first
            if let `asset` = asset {
                
                cell.imageView.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: self.frame.size) { _ in
                    
                }
            } else if let data = photo.data {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "popBigImage"), object: nil, userInfo: ["image" : cell.imageView.image])
        }
//        if let photo = card?.photos[indexPath.item] {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "popBigImage"), object: nil, userInfo: ["photo" : photo])
//        }
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
