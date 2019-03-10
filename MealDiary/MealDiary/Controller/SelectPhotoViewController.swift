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
    var photos: BehaviorRelay<[Any]> = BehaviorRelay<[Any]>(value: [])
    var selectedIndexPaths: BehaviorRelay<[IndexPath]> = BehaviorRelay<[IndexPath]>(value: [])
    var dictionary: [Int: Int] = [:]
    let nextButton = UIButton(type: .system)
    let disposeBag = DisposeBag()
    var checkedPhotos: [Photo] = []
    
    func setCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: SelectPhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SelectPhotoCollectionViewCell.identifier)
        
        photos.asObservable().bind(to: collectionView.rx.items(cellIdentifier: SelectPhotoCollectionViewCell.identifier, cellType: SelectPhotoCollectionViewCell.self)){
            [weak self] (item, photo, cell) in
            guard let `self` = self else { return }

            cell.index = self.dictionary[item] ?? 0
            
            if let photoAsset = photo as? PHAsset {
                cell.setUp(with: photoAsset)
            } else if let photo = photo as? Photo {
                if let data = photo.data {
                    cell.setUp(with: data, assetIdentifier: photo.identifier)
                    let indexPath = IndexPath(item: item, section: 0)
                    var paths = self.selectedIndexPaths.value
                    paths.append(indexPath)
                    self.selectedIndexPaths.accept(paths)
                    
                    let index = paths.firstIndex(of: indexPath) ?? 0
                    self.dictionary[indexPath.item] = index + 1
                    cell.check(index: index + 1)
                }
            }
            
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                if cell.checked {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    
                    guard let index = selectedIndexPaths.firstIndex(of: indexPath) else { return }
                    selectedIndexPaths.remove(at: index)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count == 0 {
                        self.nextButton.isEnabled = false
                    }
                    
                    cell.uncheck()
                } else {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    selectedIndexPaths.append(indexPath)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count != 0 {
                        self.nextButton.isEnabled = true
                    }
                }
                
                
                let photo = cell.getPhoto()
                self.checkedPhotos.append(photo)
                
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                if cell.checked {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    
                    guard let index = selectedIndexPaths.firstIndex(of: indexPath) else { return }
                    selectedIndexPaths.remove(at: index)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count == 0 {
                        self.nextButton.isEnabled = false
                    }
                    
                    cell.uncheck()
                } else {
                    var selectedIndexPaths = self.selectedIndexPaths.value
                    selectedIndexPaths.append(indexPath)
                    self.selectedIndexPaths.accept(selectedIndexPaths)
                    
                    if selectedIndexPaths.count != 0 {
                        self.nextButton.isEnabled = true
                    }
                }
                
                
                let photo = cell.getPhoto()
                self.checkedPhotos = self.checkedPhotos.filter{ $0.identifier != photo.identifier }
                
            }).disposed(by: disposeBag)

        selectedIndexPaths.asObservable().subscribe(onNext: { [weak self] indexPaths in
            indexPaths.forEach({ [weak self] (indexPath) in
                guard let `self` = self else { return }
                guard let index = indexPaths.firstIndex(of: indexPath) else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? SelectPhotoCollectionViewCell else { return }
                
                self.dictionary[indexPath.item] = index + 1
                cell.check(index: index + 1)
            })
        }).disposed(by: disposeBag)
    }
    
    func getImages (){
        var array: [Any] = AssetManager.fetchImages(by: nil)
        if let card = Global.shared.cardToModify {
            array = (card.photos as [Any]) + array
        }
        photos.accept(array)
    }
    
    func setNavigationBar() {
        let size = navigationController!.navigationBar.frame.height
        nextButton.setTitle("다음", for: .normal)
        self.nextButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 17)
        nextButton.addTarget(self, action: #selector(completeSelect), for: .touchUpInside)
        nextButton.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        nextButton.isEnabled = false
    }
    
    @objc func completeSelect() {
        
//        var photos: [Photo] = []
//        for index in selectedIndexPaths.value {
//
//            if let photo = self.photos.value[index.item] as? Photo {
//                photos.append(photo)
//            } else if let asset = self.photos.value[index.item] as? PHAsset {
//
//            }
        
//            if let cell = collectionView.cellForItem(at: index) as? SelectPhotoCollectionViewCell {
//                if let data = cell.data {
//                    let identifier = cell.photo.localIdentifier
//                    let photo = Photo(identifier: identifier, data: data)
//                    photos.append(photo)
//                } else {
//                    print(cell.image)
//                }
//            }
            
//        }
    
        Global.shared.photos = checkedPhotos
        
        let storyBoard = UIStoryboard(name: "Write", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("VC deinit")
    }
    
    var first: Bool = true
}

extension SelectPhotoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setNavigationBar()
        
        PHPhotoLibrary.requestAuthorization({ [weak self]
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                self?.getImages()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if first {
            titleLabel.setOrangeUnderLine()
            first = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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
