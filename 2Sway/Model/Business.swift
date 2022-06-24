//
//  Business.swift
//  2Sway
//
//  Created by Abhishek Dubey on 18/01/22.
//

import Foundation

struct Business {
    var name: String
    var logo: String
    var highestDiscount: Int
    var middleDiscount: Int
    var lowestDiscount: Int
    var numberOfDiscountsClaimedAtLowestLevel: Int
    var numberOfDiscountsClaimedAtMidLevel: Int
    var numberOfDiscountsClaimedAtHighestLevel: Int
    var totalNumberOfPromotions: Int
    var totalEngagements: Int
    var promos: [Promos]
    var locations: [Locations]
    var description: String
    var pricePoint: String
    var keywords: String
    var instagram: String
    var closingTime: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case logo
        case highestDiscount
        case middleDiscount
        case lowestDiscount
        case promos
        case locations
        case numberOfDiscountsClaimedAtLowestLevel
        case numberOfDiscountsClaimedAtMidLevel
        case numberOfDiscountsClaimedAtHighestLevel
        case totalNumberOfPromotions
        case totalEngagements
        case description
        case keywords
        case instagram
        case closingTime
        case pricePoint
    }
}

extension Business: Decodable, Encodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(name, forKey: .name)
        try val.encode(logo, forKey: .logo)
        try val.encode(highestDiscount, forKey: .highestDiscount)
        try val.encode(middleDiscount, forKey: .middleDiscount)
        try val.encode(lowestDiscount, forKey: .lowestDiscount)
        try val.encode(locations, forKey: .locations)
        try val.encode(promos, forKey: .promos)
        try val.encode(numberOfDiscountsClaimedAtLowestLevel, forKey: .numberOfDiscountsClaimedAtLowestLevel)
        try val.encode(numberOfDiscountsClaimedAtMidLevel, forKey: .numberOfDiscountsClaimedAtMidLevel)
        try val.encode(numberOfDiscountsClaimedAtHighestLevel, forKey: .numberOfDiscountsClaimedAtHighestLevel)
        try val.encode(totalNumberOfPromotions, forKey: .totalNumberOfPromotions)
        try val.encode(totalEngagements, forKey: .totalEngagements)
        try val.encode(description, forKey: .description)
        try val.encode(keywords, forKey: .keywords)
        try val.encode(instagram, forKey: .instagram)
        try val.encode(closingTime, forKey: .closingTime)
        try val.encode(pricePoint, forKey: .pricePoint)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        logo = try values.decode(String.self, forKey: .logo)
        highestDiscount = try values.decode(Int.self, forKey: .highestDiscount)
        middleDiscount = try values.decode(Int.self, forKey: .middleDiscount)
        lowestDiscount = try values.decode(Int.self, forKey: .lowestDiscount)
        promos = try values.decode([Promos].self, forKey: .promos)
        locations = try values.decode([Locations].self, forKey: .locations)
        numberOfDiscountsClaimedAtLowestLevel = try values.decode(Int.self, forKey: .numberOfDiscountsClaimedAtLowestLevel)
        numberOfDiscountsClaimedAtMidLevel = try values.decode(Int.self, forKey: .numberOfDiscountsClaimedAtMidLevel)
        numberOfDiscountsClaimedAtHighestLevel = try values.decode(Int.self, forKey: .numberOfDiscountsClaimedAtHighestLevel)
        totalNumberOfPromotions = try values.decode(Int.self, forKey: .totalNumberOfPromotions)
        totalEngagements = try values.decode(Int.self, forKey: .totalEngagements)
        description = try values.decode(String.self, forKey: .description)
        keywords = try values.decode(String.self, forKey: .keywords)
        instagram = try values.decode(String.self, forKey: .instagram)
        closingTime = try values.decode(String.self, forKey: .closingTime)
        pricePoint = try values.decode(String.self, forKey: .pricePoint)
    }
}

//Locations Model

struct Locations {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

extension Locations: Decodable, Encodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(latitude, forKey: .latitude)
        try val.encode(longitude, forKey: .longitude)
    }
}


// Promos Model

struct Promos {
    var name: String
    var description: String
    var highestDiscount: Int
    var middleDiscount: Int
    var lowestDiscount: Int
    var highestView: Int
    var middleView: Int
    var lowestView: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case highestDiscount
        case middleDiscount
        case lowestDiscount
        case highestView
        case middleView
        case lowestView
    }
}

extension Promos: Decodable, Encodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(name, forKey: .name)
        try val.encode(description, forKey: .description)
        try val.encode(highestDiscount, forKey: .highestDiscount)
        try val.encode(middleDiscount, forKey: .middleDiscount)
        try val.encode(lowestDiscount, forKey: .lowestDiscount)
        try val.encode(highestView, forKey: .highestView)
        try val.encode(middleView, forKey: .middleView)
        try val.encode(lowestView, forKey: .lowestView)
    }
}
struct LatestVersion {

}
