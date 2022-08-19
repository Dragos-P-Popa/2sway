//
//  Bill.swift
//  2Sway
//
//  Created by Dragos Popa on 07/08/2022.
//

import Foundation

struct Bill {
    
    var tableID: Int
    var restaurant: String
    var items: [Item]
    var discountApplied: Int = 0
    var paid: Bool = false
    
    
    init() {
        self.tableID = 0
        self.restaurant = ""
        self.items = []
        self.discountApplied = 0
        self.paid = false
    }
    
    enum CodingKeys: String, CodingKey {
        case tableID = "tableID"
        case restaurant = "restaurant"
        case items
        case discountApplied = "discountApplied"
        case paid = "paid"
    }
        
    func discountItems(){
        // for i in items
        //      i.discountItem()
    }

}

struct Item: Encodable, Decodable {
    
    var name: String
    var price: Int = 0
    var discounted: Bool = false
    
    init() {
        self.name = ""
        self.price = 0
        self.discounted = false
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case price = "price"
        case discounted = "discounted"
    }
    
    func discountItem(percentageDiscount: Int){
        //apply discounts & return new items
    }
}

extension Bill: Encodable, Decodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(tableID, forKey: .tableID)
        try val.encode(restaurant, forKey: .restaurant)
        try val.encode(items, forKey: .items)
        try val.encode(discountApplied, forKey: .discountApplied)
        try val.encode(paid, forKey: .paid)
    }
    
    init(from decoder: Decoder) throws {
        var value = try decoder.container(keyedBy: CodingKeys.self)
        tableID = try value.decode(Int.self, forKey: .tableID)
        restaurant = try value.decode(String.self, forKey: .restaurant)
        items = try value.decode([Item].self, forKey: .items)
        discountApplied = try value.decode(Int.self, forKey: .discountApplied)
        paid = try value.decode(Bool.self, forKey: .paid)
    }
}
