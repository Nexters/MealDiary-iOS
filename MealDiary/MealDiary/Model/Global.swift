//
//  Global.swift
//  MealDiary
//
//  Created by mac on 2019. 2. 19..
//  Copyright © 2019년 clap. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class Global {
    static let shared: Global = Global()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var cardToModify: ContentCard? = nil
    var cards: BehaviorRelay<[ContentCard]> = BehaviorRelay<[ContentCard]>(value: [])
    var searchHistory: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    var mainFilterType: filterType = .date
    var searchFilterType: filterType = .date
    
    var photos: [Photo] = []
    var titleText: String = ""
    var detailText: String = ""
    var hashTagList: [String] = []
    var restaurantName: String = ""
    var restaurantLocation: String = ""
    var restaurantTotalCount: Int = 0
    var restaurantLatitude: Double = 0
    var restaurantLongitude: Double = 0
    var score: Int = 0
    var restaurantNameArray: [String] = []
    var restaurantLocationArray: [String] = []
    
    init() {
        let cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        var cardArray: [ContentCard] = []
        for key in cardDict.keys {
            let value = cardDict[key]
            if let data = value as? Data, let card = try? decoder.decode(ContentCard.self, from: data) {
                cardArray.append(card)
            }
        }
        cardArray = filter(cards: cardArray, by: mainFilterType)
        cards.accept(cardArray)
        
        var historyArray = AssetManager.getArrayData(for: DictKeyword.searchHistory.rawValue)
        if historyArray.isEmpty {
            historyArray.append("검색 기록이 없습니다.")
        }
        searchHistory.accept(historyArray)
        
    }
    
    func filter(cards: [ContentCard],by type: filterType) -> [ContentCard] {
        var filteredCards = cards
        switch type {
        case .date:
            filteredCards.sort(by: { $0.date > $1.date })
//        case .distance:
//            ()
        case .score:
            filteredCards.sort(by: { $0.score > $1.score })
        }
        return filteredCards
    }
    
    func refresh() {
        photos = []
        titleText = ""
        detailText = ""
        hashTagList = []
        restaurantName = ""
        restaurantLocation = ""
        restaurantLatitude = 0
        restaurantLongitude = 0
        score = 0
        
        cardToModify = nil
    }
    
    func save() {
        let card = ContentCard(id: UUID().uuidString, photos: photos, titleText: titleText, detailText: detailText, hashTagList: hashTagList, restaurantName: restaurantName, restaurantLocation: restaurantLocation, restaurantLatitude: restaurantLatitude, restaurantLongitude: restaurantLongitude, date: Date(), score: score)
        
        guard let data = try? encoder.encode(card) else { return }
        var cardArray = cards.value
        cardArray.append(card)
        cardArray = filter(cards: cardArray, by: mainFilterType)
        cards.accept(cardArray)
        
        var cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        cardDict[card.id] = data
        AssetManager.save(data: cardDict, for: DictKeyword.card.rawValue)
    }
    
    func modify() {
        let id = cardToModify?.id ?? UUID().uuidString
        let card = ContentCard(id: id, photos: photos, titleText: titleText, detailText: detailText, hashTagList: hashTagList, restaurantName: restaurantName, restaurantLocation: restaurantLocation, restaurantLatitude: restaurantLatitude, restaurantLongitude: restaurantLongitude, date: Date(), score: score)
        
        guard let data = try? encoder.encode(card) else { return }
        var cardArray = cards.value
        for i in 0..<cardArray.count {
            if cardArray[i].id == id {
                cardArray.remove(at: i)
                break
            }
        }
        cardArray.append(card)
        cardArray = filter(cards: cardArray, by: mainFilterType)
        cards.accept(cardArray)
        
        var cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        cardDict[card.id] = data
        AssetManager.save(data: cardDict, for: DictKeyword.card.rawValue)
    }
    
    func delete(card: ContentCard) {
        var cardArray = cards.value
        for i in 0..<cardArray.count {
            let c = cardArray[i]
            if c.id == card.id {
                cardArray.remove(at: i)
                cards.accept(cardArray)
                break
            }
        }
        
        var cardDict = AssetManager.getDictData(for: DictKeyword.card.rawValue)
        cardDict.removeValue(forKey: card.id)
        AssetManager.save(data: cardDict, for: DictKeyword.card.rawValue)
    }
    
    func appendSearch(keyword: String) {
        var historyArray = AssetManager.getArrayData(for: DictKeyword.searchHistory.rawValue)
        historyArray.insert(keyword, at: 0)
        AssetManager.save(data: historyArray, for: DictKeyword.searchHistory.rawValue)
        searchHistory.accept(historyArray)
    }
    
    func removeSearch(index: Int) {
        var historyArray = AssetManager.getArrayData(for: DictKeyword.searchHistory.rawValue)
        historyArray.remove(at: index)
        AssetManager.save(data: historyArray, for: DictKeyword.searchHistory.rawValue)
        searchHistory.accept(historyArray)
    }
    
    func searchBy(_ query: String) -> [ContentCard] {
        var searchResult: [ContentCard] = []
        for card in cards.value {
            if card.titleText.contains(query) {
                searchResult.append(card)
            } else if card.hashTagList.contains(query) {
                searchResult.append(card)
            }
        }
        searchResult = filter(cards: searchResult, by: searchFilterType)
        return searchResult
    }
}

enum DictKeyword: String {
    case card
    case hashTag
    case firstVist
    case searchHistory
}
