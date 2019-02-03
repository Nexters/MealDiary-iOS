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
        
    }
}

extension SelectPhotoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = navigationController!.navigationBar.frame.height
        setCollectionView()
        setNavigationBar()
        titleLabel.setOrangeUnderLineView(yConst: height)
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                self.getImages()
            }
        })
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

