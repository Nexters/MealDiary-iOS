//
//  WriteMealDiaryViewController.swift
//  MealDiary
//
//  Created by 박수현 on 04/02/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class WriteMealDiaryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var mealDiaryTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    let completeButton = UIButton(type: .system)
    var searchedTagArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.setUp()
    }
    
    func setUp() {
        self.titleLabel.setOrangeUnderLine()
        self.setNavigationBar()
        self.setTableView()
        self.completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
    }
    
    func setNavigationBar() {
        self.completeButton.setTitle("완료", for: .normal)
        self.completeButton.titleLabel?.font = UIFont(name: "SpoqaHanSans-Regular", size: 16)
        self.completeButton.tintColor = UIColor(red: 159/255, green: 164/255, blue: 165/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
    }
    
    func setTableView(){
        self.tableView.register(UINib(nibName: TagTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TagTableViewCell.identifier)
    }
    
    func searchTag(isTagWord: String) {
        if isTagWord.count < 1 {
            self.tableView.isHidden = true
            self.mealDiaryTextView.isHidden = false
            return
        }
        
        if isTagWord.prefix(1) != "#" {
            self.tableView.isHidden = true
            self.mealDiaryTextView.isHidden = false
        }
        
        if let tagArray = UserDefaults.standard.stringArray(forKey: "tag") {
            let tagWord = isTagWord.dropFirst()
            let filtered = tagArray.filter { $0.contains(tagWord) }
            searchedTagArray = filtered
            if filtered.count < 1 {
                self.tableView.isHidden = true
                self.mealDiaryTextView.isHidden = false
            } else {
                searchedTagArray = filtered
                self.tableView.isHidden = false
                self.mealDiaryTextView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    func saveTag() {
        guard let tagTextField = self.tagTextField.text else {
            return
        }
        
        let tagWords = tagTextField.components(separatedBy: " ")
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
    
    @IBAction func tagTextFieldEditingChanged(_ sender: Any) {
        guard let tagTextField = self.tagTextField.text else {
            return
        }
        print("tag: \(tagTextField)")
        
        
        if tagTextField.suffix(1) == "#" {
            //self.tagTextField.text = tagTextField
        }
        
        let words = tagTextField.components(separatedBy: " ")
        for word in words {
            searchTag(isTagWord: word)
        }
    }
    
    @objc func tapCompleteButton(sender: UIButton) {
        self.saveTag()
        let storyBoard = UIStoryboard(name: "SelectPhoto", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "SelectPhotoViewController") as? SelectPhotoViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - TextViewDelegate
extension WriteMealDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if mealDiaryTextView.isFirstResponder, mealDiaryTextView.text == "식후감" {
            mealDiaryTextView.text = ""
            mealDiaryTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if mealDiaryTextView.text == "" {
            mealDiaryTextView.text = "식후감"
            mealDiaryTextView.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.6)
        }
    }
}


//MARK: - TableViewDelegate
extension WriteMealDiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? TagTableViewCell else {
            fatalError("Misconfigured cell type!")
        }
        
        guard let tagTextField = self.tagTextField.text else {
            return
        }
        
        if let selectedTagText = cell.tagLabel.text?.dropFirst() {
            self.tagTextField.text = tagTextField + String(selectedTagText)
        }
    }
}


//MARK: - TableViewDataSource
extension WriteMealDiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedTagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as? TagTableViewCell else {
            fatalError("Misconfigured cell type!")
        }
        
        cell.tagLabel.text = searchedTagArray[indexPath.row]
        
        return cell
    }
}


//MARK: - TextFieldDelegate
extension WriteMealDiaryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if tagTextField.text == "" {
            tagTextField.text = "#"
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let tagTextField = self.tagTextField.text else {
            fatalError()
        }

        if string == " " {
            self.tagTextField.text = tagTextField + " #"
            print("space bar was pressed")
        }
        return true
    }

}
