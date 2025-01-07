//
//  Restaurant.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/27.
//

import Foundation

struct Restaurant: Equatable, Identifiable {
    let id: UUID
    let title: String?
    let genre: Genre?
    let address: String?
    let stars: Double?
    let range: String?
    let latitude: Double?
    let longitude: Double?
    
    enum Genre {
        case curry
        case steak
        case hotpot
        case coffee
    }
}

// MARK: - 塞假資料
extension Restaurant {
    static func dummyRestaurants() -> [Restaurant] {
        [
            Restaurant(id: UUID(),
                       title: "和牛涮",
                       genre: .hotpot,
                       address: "106, Taipei City, Da'an District, Section 4, Zhongxiao E Rd, 128號2樓",
                       stars: 4.8,
                       range: "$$",
                       latitude: 25.042846889309704,
                       longitude: 121.54801699557817),
            
            Restaurant(id: UUID(),
                       title: "莫宰羊 麻辣鍋",
                       genre: .hotpot,
                       address: "106台北市大安區敦化南路一段233巷28號",
                       stars: 4.6,
                       range: "$$",
                       latitude: 25.039465468866382,
                       longitude: 121.54848645985097),
            
            Restaurant(id: UUID(),
                       title: "Smith & Wollensky Taipei",
                       genre: .steak,
                       address: "110台北市信義區松仁路100號47樓",
                       stars: 4.5,
                       range: "$$$",
                       latitude: 25.033009623527575,
                       longitude: 121.56711036419799),
            
            Restaurant(id: UUID(),
                       title: "咖哩樹",
                       genre: .curry,
                       address: "106台北市大安區仁愛路四段345巷4弄2號",
                       stars: 4.7,
                       range: "$$",
                       latitude: 25.03901641736496,
                       longitude: 121.55335668674897),
            
            Restaurant(id: UUID(),
                       title: "Simple Kaffa",
                       genre: .coffee,
                       address: "106台北市大安區仁愛路四段27巷7號",
                       stars: 4.4,
                       range: "$$",
                       latitude: 25.037977599477392,
                       longitude: 121.54481654604619)
        ]
    }
}
