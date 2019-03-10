//
//  WriteDiaryViewController.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 17..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var tagTableView = UITableView()
    private var restaurantTableView = UITableView()
    private var searchedTagArray = [String]()
    private var hashTagArray = [String]()
    private let host = "http://dapi.kakao.com/v2/local/search/keyword.json"
    private let authorization = "KakaoAK b8a02da2a8a5887d84233e61a6a1994b"
    
    lazy var titleTextField = UITextField()
    lazy var textView = UITextView()
    lazy var hashTagTextField = UITextField()
    lazy var restaurantTextField = UITextField()
    
    lazy var bottomView1 = UIView()
    lazy var bottomView2 = UIView()
    lazy var bottomView3 = UIView()
    lazy var bottomView4 = UIView()
    lazy var textViewPlaceHolder = UILabel()
    
    var keyboardFrame = CGRect(origin: .zero, size: .zero)
    let completeButton = UIButton(type: .system)
    let disposeBag = DisposeBag()
    
    func adjustForKeyboard() {
        guard keyboardFrame.size != .zero else { return }
        
        if titleTextField.isFirstResponder {
            adjustFirstResponder(view: titleTextField)
        } else if textView.isFirstResponder {
            adjustFirstResponder(view: textView)
        } else if hashTagTextField.isFirstResponder {
            scrollToFirstResponder(view: hashTagTextField)
        } else if restaurantTextField.isFirstResponder {
            scrollToFirstResponder(view: restaurantTextField)
        }
        scrollView.isScrollEnabled = true
    }
    
    func scrollToFirstResponder(view: UIView) {
        let viewStartY = view.frame.origin.y + 10
        scrollView.contentSize.height -= viewStartY
        scrollView.contentOffset.y += viewStartY
        
        restaurantTableView.isHidden = true
        tagTableView.isHidden = true
        
        restaurantTableView.frame = CGRect(x: 0, y: restaurantTextField.frame.origin.y + restaurantTextField.frame.size.height + 5, width: scrollView.frame.size.width, height: scrollView.frame.height - keyboardFrame.height - view.frame.height)
        
        tagTableView.frame = CGRect(x: 0, y: hashTagTextField.frame.origin.y + hashTagTextField.frame.size.height + 5, width: scrollView.frame.size.width, height: scrollView.frame.height - keyboardFrame.height - view.frame.height)
    }
    
    func adjustFirstResponder(view: UIView) {
        let scrollViewY = scrollView.frame.origin.y
        let viewEndY = scrollViewY + view.frame.origin.y + view.frame.size.height + 15
        let keyboardY = keyboardFrame.origin.y
        
        if viewEndY > keyboardY {
            let difference = keyboardY - viewEndY
            scrollView.contentSize.height += difference
            scrollView.contentOffset.y -= difference
        }
    }
    
    @objc func keyboardInteraction(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        keyboardFrame = keyboardViewEndFrame
        adjustForKeyboard()
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.isScrollEnabled = true
            scrollView.contentSize = CGSize(width: view.frame.width, height: bottomView4.frame.origin.y + 40)
        }
    }
    
    func setTableView() {
        //tag tableView
        tagTableView = UITableView(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: 48 * 5))
        tagTableView.separatorStyle = .none
        tagTableView.backgroundColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1)
        tagTableView.register(UINib(nibName: TagHistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TagHistoryTableViewCell.identifier)
        
        //restaurant tableView
        restaurantTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48 * 5))
        restaurantTableView.separatorStyle = .none
        restaurantTableView.backgroundColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1)
        restaurantTableView.register(UINib(nibName: SearchRestaurantTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchRestaurantTableViewCell.identifier)
        
        tagTableView.dataSource = self
        tagTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        
        scrollView.addSubview(tagTableView)
        scrollView.addSubview(restaurantTableView)
        
        tagTableView.isHidden = true
        restaurantTableView.isHidden = true
    }
    
    func setScrollView() {
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(textView)
        scrollView.addSubview(textViewPlaceHolder)
        scrollView.addSubview(hashTagTextField)
        scrollView.addSubview(restaurantTextField)
        scrollView.addSubview(bottomView1)
        scrollView.addSubview(bottomView2)
        scrollView.addSubview(bottomView3)
        scrollView.addSubview(bottomView4)
        
        titleTextField.delegate = self
        textView.delegate = self
        hashTagTextField.delegate = self
        restaurantTextField.delegate = self
        
        titleTextField.font = UIFont.systemFont(ofSize: 16.0)
        textView.font = UIFont.systemFont(ofSize: 16.0)
        hashTagTextField.font = UIFont.systemFont(ofSize: 16.0)
        restaurantTextField.font = UIFont.systemFont(ofSize: 16.0)
        textViewPlaceHolder.font = UIFont.systemFont(ofSize: 16.0)
        textViewPlaceHolder.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.6)
        
        hashTagTextField.addTarget(self, action: #selector(hashTagTextFieldDidChange(_:)), for: .editingChanged)
        restaurantTextField.addTarget(self, action: #selector(restaurantTextFieldDidChange(_:)), for: .editingChanged)
        
        titleTextField.clearButtonMode = .whileEditing
        hashTagTextField.clearButtonMode = .whileEditing
        restaurantTextField.clearButtonMode = .whileEditing
        
        bottomView2.backgroundColor = UIColor.paleGray
        bottomView3.backgroundColor = UIColor.paleGray
        bottomView4.backgroundColor = UIColor.paleGray
        
        setUpPlaceHolder()
        
        titleTextField.frame = CGRect(x: 30, y: 0, width: view.frame.width - 60, height: 48)
        bottomView1.frame = CGRect(x: 20, y: titleTextField.frame.origin.y + titleTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        bottomView1.backgroundColor = UIColor.paleGray
        textViewPlaceHolder.frame = CGRect(x: 30, y: bottomView1.frame.origin.y + 5, width: 100, height: 48)
        
        adjustTextViewFrame()
    }
    
    func adjustTextViewFrame(with height: CGFloat = 36.0) {
        textView.frame = CGRect(x: 25, y: bottomView1.frame.origin.y + 5, width: view.frame.width - 50, height: height + 12)
        textView.contentInset.top = (textView.frame.height - textView.contentSize.height) / 2
        bottomView2.frame = CGRect(x: 20, y: textView.frame.origin.y + textView.frame.height, width: self.view.frame.width - 40, height: 1)
        
        hashTagTextField.frame = CGRect(x: 30, y: bottomView2.frame.origin.y + 5, width: view.frame.width - 60, height: 48)
        bottomView3.frame = CGRect(x: 20, y: hashTagTextField.frame.origin.y + hashTagTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        
        restaurantTextField.frame = CGRect(x: 30, y: bottomView3.frame.origin.y + 5, width: view.frame.width - 60, height: 48)
        bottomView4.frame = CGRect(x: 20, y: restaurantTextField.frame.origin.y + restaurantTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: bottomView4.frame.origin.y + 40)
        
        adjustForKeyboard()
        
        titleTextField.rx.text.subscribe(onNext: { [weak self] (text) in
            if !(text?.isEmpty ?? true) && !(self?.textView.text.isEmpty ?? true) {
                self?.enableCompletionButton()
            } else {
                self?.disableCompletionButton()
            }
        }).disposed(by: disposeBag)
    }
    
    func setTextView() {
        textView.rx.contentOffset
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] (offset) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.adjustTextViewFrame(with: self.textView.contentSize.height)
            }
        }).disposed(by: disposeBag)
        
        textView.rx.text
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { [weak self] (text) in
                guard let `self` = self else { return }
                if self.textView.contentSize.height < (self.textView.frame.height - 12) {
                    DispatchQueue.main.async {
                        self.adjustTextViewFrame(with: self.textView.contentSize.height)
                    }
                }
                
                if text?.count ?? 0 > 0 {
                    self.textViewPlaceHolder.isHidden = true
                } else {
                    self.textViewPlaceHolder.isHidden = false
                }
                
                if !(self.titleTextField.text?.isEmpty ?? true) && !(text?.isEmpty ?? true) {
                    self.enableCompletionButton()
                } else {
                    self.disableCompletionButton()
                }
                
        }).disposed(by: disposeBag)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func enableCompletionButton() {
        self.completeButton.tintColor = .black
        self.completeButton.isEnabled = true
    }
    
    func disableCompletionButton() {
        self.completeButton.tintColor = UIColor(red: 159/255, green: 164/255, blue: 165/255, alpha: 1)
        self.completeButton.isEnabled = false
    }
    
    func setNavigationBar() {
        
        let size = navigationController!.navigationBar.frame.height
        
        self.completeButton.setTitle("다음", for: .normal)
        self.completeButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 17)
        disableCompletionButton()
        completeButton.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        
        completeButton.rx.tap.subscribe( onNext: { [weak self] in
            guard let `self` = self else { return }
            let storyBoard = UIStoryboard(name: "Rate", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "RateViewController") as? RateViewController else {
                return
            }
            
            // To-do : 수현
            self.saveTag()
            
            Global.shared.titleText = self.titleTextField.text ?? ""
            Global.shared.detailText = self.textView.text
            Global.shared.hashTagList = self.hashTagArray
            Global.shared.restaurantName = self.restaurantTextField.text ?? ""
            Global.shared.restaurantLatitude = 0
            Global.shared.restaurantLongitude = 0
            //
            
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    func setUpPlaceHolder() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "iconStar")
        attachment.bounds = CGRect(x: 6, y: 10, width: 6, height: 6)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let placeHolder = NSMutableAttributedString(string: "제목")
        placeHolder.append(attachmentStr)
        
        let placeHolder_detail = NSMutableAttributedString(string: "식후감")
        placeHolder_detail.append(attachmentStr)
        textViewPlaceHolder.attributedText = placeHolder_detail
        
        titleTextField.attributedPlaceholder = placeHolder
        hashTagTextField.placeholder = "#태그"
        restaurantTextField.placeholder = "식당이름"
    }
    
    @objc func hashTagTextFieldDidChange(_ textField: UITextField) {
        let words = textField.text?.components(separatedBy: " ")
        for word in words ?? [] {
            searchTag(isTagWord: word)
        }
    }
    
    @objc func restaurantTextFieldDidChange(_ textField: UITextField) {
        self.searchPlace(keyword: textField.text ?? "")
    }
    
    func searchTag(isTagWord: String) {
        if isTagWord.count < 1 {
            self.tagTableView.isHidden = true
            return
        }
        
        if isTagWord.prefix(1) != "#" {
            self.tagTableView.isHidden = true
        }
        
        if let tagArray = UserDefaults.standard.stringArray(forKey: "tag") {
            let tagWord = isTagWord.dropFirst()
            let filtered = tagArray.filter { $0.contains(tagWord) }
            
            self.searchedTagArray = filtered
            
            if filtered.count < 1 {
                self.tagTableView.isHidden = true
            } else {
                self.tagTableView.isHidden = false
            }
            
            self.tagTableView.reloadData()
        }
    }
    
    func saveTag() {
        guard let hashTagTextField = self.hashTagTextField.text else {
            return
        }
        
        let tagWords = hashTagTextField.components(separatedBy: " ")
        self.hashTagArray = tagWords
        
        for tagWord in tagWords {
            if var tagArray = UserDefaults.standard.stringArray(forKey: "tag") {
                if !tagArray.contains(tagWord) {
                    tagArray.append(tagWord)
                    UserDefaults.standard.set(tagArray, forKey: "tag")
                }
            } else {
                var tagArray = [String]()
                tagArray.append(tagWord)
                UserDefaults.standard.set(tagArray, forKey: "tag")
            }
        }
    }
    
    func searchPlace(keyword: String) {
        if keyword.count < 1 {
            self.restaurantTableView.isHidden = true
            return
        }
        
        self.restaurantTableView.isHidden = false
    
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
                
                if dataCount < 1 {
                    self.restaurantTableView.isHidden = true
                }
                
                Global.shared.restaurantTotalCount = dataCount
                
                var placeArray = [String]()
                var addressArray = [String]()
                
                for i in 0..<dataCount {
                    guard let place = dataJSON["documents"][i]["place_name"].string else { return }
                    guard let address = dataJSON["documents"][i]["address_name"].string else { return }
                    
                    placeArray.append(place)
                    addressArray.append(address)
                }
                
                Global.shared.restaurantNameArray = placeArray
                Global.shared.restaurantLocationArray = addressArray
                
               self.restaurantTableView.reloadData()
        }
    }
    
    deinit {
        print("VC deinit")
    }
}

extension WriteDiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        setTextView()
        setTableView()
        setNavigationBar()
        
        if let card = Global.shared.cardToModify {
            titleTextField.text = card.titleText
            textView.text = card.detailText
            var hashTag = ""
            card.hashTagList.forEach { hashTag += ($0 + " ") }
            hashTagTextField.text = hashTag
            restaurantTextField.text = card.restaurantName
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.setOrangeUnderLine()
        restaurantTableView.frame = CGRect(x: 0, y: restaurantTextField.frame.origin.y + restaurantTextField.frame.size.height + 5, width: scrollView.frame.size.width, height: 50)
        
        tagTableView.frame = CGRect(x: 0, y: hashTagTextField.frame.origin.y + hashTagTextField.frame.size.height + 5, width: scrollView.frame.size.width, height: 50)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardInteraction(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardInteraction(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

extension WriteDiaryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleTextField {
            bottomView1.backgroundColor = UIColor.darkGray
        } else if textField == hashTagTextField {
            bottomView3.backgroundColor = UIColor.darkGray
            tagTableView.isHidden = false
        } else {
            bottomView4.backgroundColor = UIColor.darkGray
            restaurantTableView.isHidden = false
        }
        
        adjustForKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tagTableView.isHidden = true
        restaurantTableView.isHidden = true
        
        if textField == titleTextField {
            bottomView1.backgroundColor = UIColor.paleGray
        } else if textField == hashTagTextField {
            bottomView3.backgroundColor = UIColor.paleGray
        } else {
            bottomView4.backgroundColor = UIColor.paleGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let words = text.components(separatedBy: " ")
        var tagWords = [String]()
       
        if words.count > 5 {
            textField.deleteBackward()
        }
        
        return words.count < 6
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        bottomView2.backgroundColor = UIColor.darkGray
        
        adjustForKeyboard()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        bottomView2.backgroundColor = UIColor.paleGray
    }
}

extension WriteDiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tagTableView {
            return self.searchedTagArray.count < 6 ? self.searchedTagArray.count : 5
        } else {
            return Global.shared.restaurantTotalCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tagTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagHistoryTableViewCell.identifier, for: indexPath) as? TagHistoryTableViewCell else {
                fatalError()
            }
            cell.tagLabel.text = searchedTagArray[indexPath.row]
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantTableViewCell", for: indexPath) as? SearchRestaurantTableViewCell else {
            fatalError()
        }
        cell.placeLabel.text = Global.shared.restaurantNameArray[indexPath.row]
        cell.locationLabel.text = Global.shared.restaurantLocationArray[indexPath.row]
        return cell
    }
}

extension WriteDiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == tagTableView ? 48 : 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tagTableView {
            tableView.isHidden = false
            guard let cell = tableView.cellForRow(at: indexPath) as? TagHistoryTableViewCell else {
                fatalError("Misconfigured cell type!")
            }
            
            guard let hashTagTextField = self.hashTagTextField.text else {
                return
            }
            
            if let selectedTagText = cell.tagLabel.text {
                if let index = hashTagTextField.range(of: "#")?.lowerBound {
                    let substring = hashTagTextField.suffix(from: index)
                    let string = String(substring)
                    var words = string.components(separatedBy: " ")
                    
                    words.removeLast()
                    words.append(selectedTagText)
                    
                    var hashTagText: String = ""
                    for word in words {
                        if let word = word as String? {
                            hashTagText += "\(word) "
                        }
                    }
                    
                    self.hashTagTextField.text = hashTagText
                    tableView.isHidden = true
                }
                
            }
        } else {
            tableView.isHidden = false
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchRestaurantTableViewCell else {
                fatalError("Misconfigured cell type!")
            }
            
            if let selectedTagText = cell.placeLabel.text {
                self.restaurantTextField.text = String(selectedTagText)
                Global.shared.restaurantLocation = cell.locationLabel.text ?? ""
                tableView.isHidden = true
                self.view.endEditing(true)
            }
        }
    }
}
