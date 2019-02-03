//
//  DetailViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 3..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var card: BehaviorRelay<[Card]?> = BehaviorRelay<[Card]?>(value: nil)

    @objc func tabFeedMoreButton(sender: UIButton) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        let modifyActionButton = UIAlertAction(title: "수정", style: .default) { action -> Void in
            print("수정")
        }
        actionSheetController.addAction(modifyActionButton)

        let deleteActionButton = UIAlertAction(title: "삭제", style: .destructive) { action -> Void in
            print("삭제")
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func setUp(with card: Card) {
        self.card.accept([card])
    }
    
    func setNavigationBar() {
        let size = navigationController!.navigationBar.frame.height
        
        let feedMoreButton = UIButton(type: .system)
        feedMoreButton.setImage(UIImage(named: "iconIcFeedMoreDefault")?.withRenderingMode(.alwaysOriginal), for: .normal)
        feedMoreButton.imageView?.contentMode = .scaleAspectFit
        feedMoreButton.addTarget(self, action: #selector(tabFeedMoreButton), for: .touchUpInside)
        
        let widthConstraint = feedMoreButton.widthAnchor.constraint(equalToConstant: size)
        let heightConstraint = feedMoreButton.heightAnchor.constraint(equalToConstant: size)
        widthConstraint.isActive = true
        heightConstraint.isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: feedMoreButton)
    }
    
    func setTableView() {
        tableView.register(UINib(nibName: DetailCardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DetailCardTableViewCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        card.asObservable().flatMap { Observable.from(optional: $0) }
            .bind(to: tableView.rx.items(cellIdentifier: DetailCardTableViewCell.identifier, cellType: DetailCardTableViewCell.self)){
            (row, card, cell) in
            cell.setUp(with: card, parentViewSize: self.view.frame.size)
        }.disposed(by: disposeBag)
    }
}

extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailCardTableViewCell.getHeight(for: card.value?[indexPath.item], parentViewSize: self.view.frame.size)
    }
}
