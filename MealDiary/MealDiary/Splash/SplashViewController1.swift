//
//  SplashViewController1.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 16..
//  Copyright © 2019년 clap. All rights reserved.
//

import UIKit

class SplashViewController1: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBAction func tabSkipButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        AssetManager.save(data: false, for: DictKeyword.firstVist.rawValue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
