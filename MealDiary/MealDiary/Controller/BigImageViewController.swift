//
//  BigImageViewController.swift
//  MealDiary
//
//  Created by jeewoong.han on 10/03/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit

class BigImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func pressCloseButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
