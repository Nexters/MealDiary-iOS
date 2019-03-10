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
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restaurantLocation: UILabel!
    @IBOutlet weak var locationView: UIView!
    
    var card: ContentCard?
    
    static let identifier = "DetailCardTableViewCell"
    
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
        cardNumberLabel.text = "1/" + card.photoDatas.count.description
        pointLabel.text = card.score.description
        restaurantNameLabel.text = card.titleText
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
    }
    
    var currentPage = 1
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1) + 1
        currentPage = page
        cardNumberLabel.text = currentPage.description + "/" + (card?.photoDatas.count.description ?? "1")
    }
}

extension DetailCardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card?.photoDatas.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if let data = card?.photoDatas[indexPath.item] {
            cell.imageView.image = UIImage(data: data)
        }
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
