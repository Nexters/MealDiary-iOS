//
//  RateViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 4..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import SwiftyGif

class RateViewController: UIViewController {
    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func changeSliderValue(_ sender: UISlider, forEvent event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                let page = Int(round(sender.value))
                if page != currentPage {
                    scrollPage(to: page)
                }
            case .ended:
                sender.setValue(Float(Int(round(sender.value))), animated: true)
            default:
                break
            }
        }
    }
    @IBAction func tabCompletRateButton(_ sender: Any) {
        Global.shared.score = Int(rateSlider.value * 10)
        if Global.shared.cardToModify != nil {
            Global.shared.modify()
        } else {
            Global.shared.save()
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    let rates = Rate.rates
    var currentPage = 0
    
    func scrollPage(to page: Int){
        currentPage = page
        let cellSize = collectionView.frame.size
        let contentOffset = collectionView.contentOffset
        if page > rates.count {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionView.scrollRectToVisible(r, animated: true)
        } else {
            let r = CGRect(x: cellSize.width * CGFloat(page), y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionView.scrollRectToVisible(r, animated: true)
        }
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: RateCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RateCollectionViewCell.identifier)
    }
    
    func setSlider() {
        rateSlider.minimumValue = 0
        rateSlider.maximumValue = Float(rates.count - 1)
        rateSlider.setValue(0, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        rateSlider.setValue(Float(page), animated: true)
        currentPage = page
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let base = scrollView.contentSize.width / CGFloat(rates.count)
        let currentX = scrollView.contentOffset.x
        var degree = (currentX.truncatingRemainder(dividingBy: base)) / base * 90
        if degree == 0 { degree = 90 }

        if collectionView.visibleCells.count == 2 {
            guard let first = collectionView.visibleCells.first?.contentView else { return }
            guard let last = collectionView.visibleCells.last?.contentView else { return }

            if (Int((currentX) / base) == 4) {
                first.layer.rotateY(degree: degree)
                last.layer.rotateY(degree: (90 - degree) * -1)
            } else if (Int(currentX / base) % 2 == 1) && (Int((currentX) / base) / 3 % 2 == 0) {
                first.layer.rotateY(degree: degree)
                last.layer.rotateY(degree: (90 - degree) * -1)
            } else {
                first.layer.rotateY(degree: (90 - degree) * -1)
                last.layer.rotateY(degree: degree)
            }
        }

        if currentX.truncatingRemainder(dividingBy: base) == 0 {
            collectionView.visibleCells.forEach{ $0.contentView.layer.rotateY(degree: 0) }
        }
    }
    
    deinit {
        print("VC deinit")
    }
    
    var viewDidLayoutSubviewsForTheFirstTime = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make sure this is the first time, else return
        guard viewDidLayoutSubviewsForTheFirstTime == true else {return}
        viewDidLayoutSubviewsForTheFirstTime = false
        
        // Create the layout
        if let card = Global.shared.cardToModify {
            let page = card.score / 10
            rateSlider.value = Float(page)
            currentPage = page
            collectionView.contentOffset.x += collectionView.frame.width * CGFloat(page)
        }
    }
}

extension RateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setSlider()
    }
}

extension RateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateCollectionViewCell.identifier, for: indexPath) as! RateCollectionViewCell
        cell.setUp(with: rates[indexPath.item])
        return cell
    }
}

extension RateViewController: UICollectionViewDelegateFlowLayout {
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


