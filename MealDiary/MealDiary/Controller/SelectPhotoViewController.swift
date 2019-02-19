//
//  SelectPhotoViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 1. 26..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class SelectPhotoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: BehaviorRelay<[PHAsset]> = BehaviorRelay<[PHAsset]>(value: [])
    var selectedIndexPaths: BehaviorRelay<[IndexPath]> = BehaviorRelay<[IndexPath]>(value: [])
    var dictionary: [Int: Int] = [:]
    let nextButton = UIButton(type: .system)
    let disposeBag = DisposeBag()
    
    func setCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: SelectPhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
        
        photos.asObservable().bind(to: collectionView.rx.items(cellIdentifier: SelectPhotoCollectionViewCell.identifier, cellType: SelectPhotoCollectionViewCell.self)){
            [weak self] (row, photoAsset, cell) in
            guard let `self` = self else { return }

            cell.index = self.dictionary[row] ?? 0
            cell.setUp(with: photoAsset)
            
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                
                var selectedIndexPaths = self.selectedIndexPaths.value
                selectedIndexPaths.append(indexPath)
                self.selectedIndexPaths.accept(selectedIndexPaths)
                
                if selectedIndexPaths.count != 0 {
                    self.nextButton.isEnabled = true
                }
                
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                var selectedIndexPaths = self.selectedIndexPaths.value
                
                guard let index = selectedIndexPaths.firstIndex(of: indexPath) else { return }
                selectedIndexPaths.remove(at: index)
                self.selectedIndexPaths.accept(selectedIndexPaths)
                
                if selectedIndexPaths.count == 0 {
                    self.nextButton.isEnabled = false
                }
                
                cell.unchecked()
                
            }).disposed(by: disposeBag)

        selectedIndexPaths.asObservable().subscribe(onNext: { indexPaths in
            indexPaths.forEach({ [weak self] (indexPath) in
                guard let `self` = self else { return }
                guard let index = indexPaths.firstIndex(of: indexPath) else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                self.dictionary[indexPath.item] = index + 1
                cell.checked(index: index + 1)
            })
        }).disposed(by: disposeBag)
    }
    
    func getImages (){
        PHPhotoLibrary.shared().register(self)
        photos.accept(AssetManager.fetchImages(by: nil))
    }
    
    func setNavigationBar() {
        nextButton.setTitle("다음", for: .normal)
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            nextButton.titleLabel?.font = font
        }
        nextButton.addTarget(self, action: #selector(completeSelect), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        nextButton.isEnabled = false
    }
    
    @objc func completeSelect() {
        var datas: [Data] = []
        for index in selectedIndexPaths.value {
            if let cell = collectionView.cellForItem(at: index) as? SelectPhotoCollectionViewCell {
                if let data = cell.imageView.image?.pngData() {
                    datas.append(data)
                    
                }
            }
        }
        let id = UUID().uuidString
        let contentCard = ContentCard(id: id, photoDatas: datas, titleText: "asdf", detailText: "", hashTagList: [], restaurantName: "", restaurantLocation: "", restaurantLatitude: 0, restaurantLongitude: 0, date: Date(), score: 100)
//        AssetManager.save(data: contentCard.getDict(), for: "card")
        
        let encoder = JSONEncoder()
        let a = try? encoder.encode(contentCard)
        print(a)
        
        let decoder = JSONDecoder()
        if let data = a, let card = try? decoder.decode(ContentCard.self, from: data) {
            
        }
        
        let storyBoard = UIStoryboard(name: "Write", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public var topDistance : CGFloat{
        get{
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                return 0
            }else{
                let barHeight=self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight
            }
        }
    }
}

extension SelectPhotoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setNavigationBar()
        titleLabel.setOrangeUnderLine()
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                self.getImages()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension SelectPhotoViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        getImages()
    }
}


extension SelectPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 3) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
