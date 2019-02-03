//
//  Card.swift
//  MealDiary
//
//  Created by jeewoong.han on 21/01/2019.
//  Copyright © 2019 clap. All rights reserved.
//

import UIKit
import Photos

struct Card {
    var photos: [UIImage]
//    var photos: [PHAsset]
    var restaurantName: String
    var point: Int
    var address: String
    var hashtagList: [String]
    var detailText: String
    var date: String
}

class sample {
    static let card = Card(photos: [UIImage(named: "sample3")!, UIImage(named: "sample2")!, UIImage(named: "sample1")!], restaurantName: "배네딕트 맛집👍🏻👍🏻", point: 20, address: "서울 강남구 역삼동 819-1 3층", hashtagList: ["한식", "감자탕", "회식", "저렴한"], detailText: "천고에 속에 안고, 우리 밥을 그들의 쓸쓸하랴? 얼음 돋고, 온갖 생의 간에 방황하였으며, 가진 얼마나 아니다. 영락과 아름답고 그들은 하여도 속잎나고, 발휘하기 있는 그들은 가치를 이것이다. 있는 가슴이 인간은 품고 전인 그들에게 기쁘며, 봄바람이다. 할지라도 보배를 따뜻한 있음으로써 반짝이는 칼이다. 소리다.이것은 피고, 가슴이 가치를 품었기 아니한 대중을 보이는 것이다. 우리 하는 놀이 미인을 대고, 이것은 끓는다. 황금시대의 불어 고동을 얼마나 풍부하게 뿐이다. 눈에 아니한 새가 그들을 인생에 것은 이상을 이상의 보라. 소금이라 인생의 이것이야말로 가슴에 소담스러운 역사를 싸인 이상 용감하고 있다. 천고에 속에 안고, 우리 밥을 그들의 쓸쓸하랴? 얼음 돋고, 온갖 생의 간에 방황하였으며, 가진 얼마나 아니다. 영락과 아름답고 그들은 하여도 속잎나고, 발휘하기 있는 그들은 가치를 이것이다. 있는 가슴이 인간은 품고 전인 그들에게 기쁘며, 봄바람이다. 할지라도 보배를 따뜻한 있음으로써 반짝이는 칼이다. 소리다.이것은 피고, 가슴이 가치를 품었기 아니한 대중을 보이는 것이다. 우리 하는 놀이 미인을 대고, 이것은 끓는다. 황금시대의 불어 고동을 얼마나 풍부하게 뿐이다. 눈에 아니한 새가 그들을 인생에 것은 이상을 이상의 보라. 소금이라 인생의 이것이야말로 가슴에 소담스러운 역사를 싸인 이상 용감하고 있다.", date: "2019.01.27")
    static let card2 = Card(photos: [UIImage(named: "sample2")!, UIImage(named: "sample3")!, UIImage(named: "sample1")!], restaurantName: "배네딕트 맛집👍🏻👍🏻", point: 20, address: "서울 강남구 역삼동 819-1 3층", hashtagList: ["한식", "감자탕", "회식", "저렴한"], detailText: "안녕", date: "2019.01.27")
    
    static let cards: [Card] = [card, card2, card, card2, card, card, card, card]
}
