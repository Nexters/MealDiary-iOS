//
//  WritePlaceViewController.swift
//  MealDiary
//
//  Created by 박수현 on 03/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WritePlaceViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let skipButton = UIButton(type: .system)
    let host = "http://dapi.kakao.com/v2/local/search/keyword.json"
    let authorization = "KakaoAK b8a02da2a8a5887d84233e61a6a1994b"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        self.setUp()
        
    }
    
    func setUp() {
        self.titleLabel.setOrangeUnderLine()
        self.setNavigationBar()
        self.setTableView()
        self.skipButton.addTarget(self, action: #selector(tapSkipButton), for: .touchUpInside)
    }
    
    func setNavigationBar() {
        self.skipButton.setTitle("Skip", for: .normal)
        self.skipButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 16)
        self.skipButton.tintColor = UIColor.primaryOrange
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
    }
    
    func setTableView(){
        self.tableView.register(UINib(nibName: PlaceListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PlaceListTableViewCell.identifier)
    }
    
    func searchPlace(keyword: String) {
        Alamofire.request(
            host,
            method: .get,
            parameters: ["query": keyword],
            encoding: URLEncoding.default,
            headers: ["Authorization": authorization]
            ).responseJSON { response in
                guard response.result.isSuccess else {
                        print("Error: \(String(describing: response.result.error))")
                        return
                }
                
                let data = response.data
                let dataJSON = JSON(data as Any)
                let dataCount = dataJSON["documents"].count
                
                MapManager.shared.totalCount = dataCount
                
                var placeArray = [String]()
                var addressArray = [String]()
                
                for i in 0..<dataCount {
                    guard let place = dataJSON["documents"][i]["place_name"].string else { return }
                    guard let address = dataJSON["documents"][i]["address_name"].string else { return }
                    
                    placeArray.append(place)
                    addressArray.append(address)
                }
                
                MapManager.shared.placeArray = placeArray
                MapManager.shared.locationArray = addressArray
                self.tableView.reloadData()
        }
    }
    @IBAction func placeTextFieldEditingChanged(_ sender: Any) {
        if let placeText = self.placeTextField.text {
            self.searchPlace(keyword: placeText)
        }
        self.tableView.isHidden = false
    }
    
    @objc func tapSkipButton(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "WriteMealDiary", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "WriteMealDiaryViewController") as? WriteMealDiaryViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - TextFieldDelegate
extension WritePlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.placeTextField.resignFirstResponder()
        return true
    }
}

//MARK: - TableViewDelegate
extension WritePlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "WriteMealDiary", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "WriteMealDiaryViewController") as? WriteMealDiaryViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - TableViewDataSource
extension WritePlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapManager.shared.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListTableViewCell", for: indexPath) as? PlaceListTableViewCell else {
            fatalError("Misconfigured cell type!")
        }
        
        if let location = MapManager.shared.locationArray {
            cell.locationLabel.text = location[indexPath.row]
        }
        
        if let place = MapManager.shared.placeArray {
            cell.placeTitleLabel.text = place[indexPath.row]
        }
        
        return cell
    }
}
