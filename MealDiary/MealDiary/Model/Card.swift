//
//  Card.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit
import Photos

struct Photo: Codable {
    var identifier: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case data
    }
    
    init(identifier: String, data: Data?) {
        self.identifier = identifier
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(data, forKey: .data)
    }
}

struct ContentCard: Codable {
    var id: String
    var photos: [Photo]
    var titleText: String
    var detailText: String
    var hashTagList: [String]
    var restaurantName: String
    var restaurantLocation: String
    var restaurantLatitude: Double
    var restaurantLongitude: Double
    var date: Date
    var score: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case photos
        case titleText
        case detailText
        case hashTagList
        case restaurantName
        case restaurantLocation
        case restaurantLatitude
        case restaurantLongitude
        case date
        case score
    }
    
    init(id: String, photos: [Photo], titleText: String, detailText: String, hashTagList: [String], restaurantName: String, restaurantLocation: String, restaurantLatitude: Double, restaurantLongitude: Double, date: Date, score: Int) {
        self.id = id
        self.photos = photos
        self.titleText = titleText
        self.detailText = detailText
        self.hashTagList = hashTagList
        self.restaurantName = restaurantName
        self.restaurantLocation = restaurantLocation
        self.restaurantLatitude = restaurantLatitude
        self.restaurantLongitude = restaurantLongitude
        self.score = score
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        photos = try values.decode([Photo].self, forKey: .photos)
        titleText = try values.decode(String.self, forKey: .titleText)
        detailText = try values.decode(String.self, forKey: .detailText)
        hashTagList = try values.decode([String].self, forKey: .hashTagList)
        restaurantName = try values.decode(String.self, forKey: .restaurantName)
        restaurantLocation = try values.decode(String.self, forKey: .restaurantLocation)
        restaurantLatitude = try values.decode(Double.self, forKey: .restaurantLatitude)
        restaurantLongitude = try values.decode(Double.self, forKey: .restaurantLongitude)
        date = try values.decode(Date.self, forKey: .date)
        score = try values.decode(Int.self, forKey: .score)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(photos, forKey: .photos)
        try container.encode(titleText, forKey: .titleText)
        try container.encode(detailText, forKey: .detailText)
        try container.encode(hashTagList, forKey: .hashTagList)
        try container.encode(restaurantName, forKey: .restaurantName)
        try container.encode(restaurantLocation, forKey: .restaurantLocation)
        try container.encode(restaurantLatitude, forKey: .restaurantLatitude)
        try container.encode(restaurantLongitude, forKey: .restaurantLongitude)
        try container.encode(date, forKey: .date)
        try container.encode(score, forKey: .score)
    }
    
//    func getDict() -> [String: Any] {
//        var dict: [String: Any] = [:]
//        var contentDict: [String: Any] = [:]
//        contentDict["photoDatas"] = photoDatas
//        contentDict["titleText"] = titleText
//        contentDict["detailText"] = detailText
//        contentDict["hashTagList"] = hashTagList
//        contentDict["restaurantName"] = restaurantName
//        contentDict["restaurantLocation"] = restaurantLocation
//        contentDict["restaurantLatitude"] = restaurantLatitude
//        contentDict["restaurantLongitude"] = restaurantLongitude
//        contentDict["score"] = score
//        dict[id] = contentDict
//        return dict
//    }
    
}

struct HashTag: Codable {
    var value: String
    var cardList: [String]
    
    enum CodingKeys: String, CodingKey {
        case value
        case cardList
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decode(String.self, forKey: .value)
        cardList = try values.decode([String].self, forKey: .cardList)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(cardList, forKey: .cardList)
    }
}

struct RateCard {
    var rateImage: UIImage
    var rateNum: Int
    var rateText: String
}

class sample {
    static let tagHistory: [String] = ["애그배내딕트", "#카이스트", "#회식", "꼬깔콘"]
}

struct Rate {
    static let gif0 = UIImage(gifName: "0")
    static let gif1 = UIImage(gifName: "1")
    static let gif2 = UIImage(gifName: "2")
    static let gif3 = UIImage(gifName: "3")
    static let gif4 = UIImage(gifName: "4")
    static let gif5 = UIImage(gifName: "5")
    
    static let rate0 = RateCard(rateImage: gif0, rateNum: 0, rateText: "다시는 안갈거야!!")
    static let rate1 = RateCard(rateImage: gif0, rateNum: 10, rateText: "다시는 안갈거야!!")
    static let rate2 = RateCard(rateImage: gif1, rateNum: 20, rateText: "언젠가 인연이 되면 또 가겠지..")
    static let rate3 = RateCard(rateImage: gif1, rateNum: 30, rateText: "언젠가 인연이 되면 또 가겠지..")
    static let rate4 = RateCard(rateImage: gif2, rateNum: 40, rateText: "먹을만..했다..")
    static let rate5 = RateCard(rateImage: gif2, rateNum: 50, rateText: "먹을만..했다..")
    static let rate6 = RateCard(rateImage: gif3, rateNum: 60, rateText: "보람찬 한 끼였다.")
    static let rate7 = RateCard(rateImage: gif3, rateNum: 70, rateText: "보람찬 한 끼였다.")
    static let rate8 = RateCard(rateImage: gif4, rateNum: 80, rateText: "뿌듯한 한 끼였다.")
    static let rate9 = RateCard(rateImage: gif4, rateNum: 90, rateText: "뿌듯한 한 끼였다.")
    static let rate10 = RateCard(rateImage: gif5, rateNum: 100, rateText: "드디어 인생 맛집을 찾았다!")
    
    static let rates: [RateCard] = [rate0, rate1, rate2, rate3, rate4, rate5, rate6, rate7, rate8, rate9, rate10]
}
