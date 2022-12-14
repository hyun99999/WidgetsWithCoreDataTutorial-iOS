//
//  MyCardDetail.swift
//  WidgetsWithCoreDataTutorial-iOS
//
//  Created by kimhyungyu on 2022/12/02.
//

//import Foundation
import UIKit

struct MyCardDetail {
    let cardName: String
    let userName: String
    let cardImage: UIImage
    
    // Widget preview 를 위해서 정적 데이터를 남겨두었다.
    static let availableMyCards = [
        MyCardDetail(cardName: "첫 번째 카드", userName: "첫현규", cardImage: UIImage(named: "background") ?? UIImage()),
        MyCardDetail(cardName: "두 번째 카드", userName: "두현규", cardImage: UIImage(named: "imgCardWidget") ?? UIImage())
    ]
}
