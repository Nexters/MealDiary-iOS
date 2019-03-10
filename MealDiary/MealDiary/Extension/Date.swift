//
//  Date.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 19..
//  Copyright © 2019년 clap. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
