//
//  User.swift
//  progressBar2
//
//  Created by Joe Feest on 23/07/2021.
//

import Foundation
import UIKit
import Firebase

struct User {
    
    //All user needed data structures
    var accountStatus: Int
    var email: String?
    var password: String?
    var name: String?
    var profilePhoto: UIImage?
    var urlString: String?
    var myPromos: [ClaimedPromo?]
    var dataThisMonth: DataThisMonth
    var totalPromosDone: Int
    var totalEngagements: Int
    var promos: [StudentPromos]
    
    init() {
        self.accountStatus = 0
        self.myPromos = []
        self.totalPromosDone = 0
        self.totalEngagements = 0
        dataThisMonth = DataThisMonth()
        self.promos = []
    }
    
    enum CodingKeys: String, CodingKey {
        case accountStatus = "accountStatus"
        case email = "email"
        case urlString = "urlString"
        case name = "name"
        case dataThisMonth = "dataThisMonth"
        case totalEngagements
        case promos
        case totalPromosDone
    }
        
    /**
     Calls onto DatabaseManager to remove user promo from Firebase Firestore.
     
     - parameter id: Promo ID as String.
     */
    func removeClaimedPromo(id: String) {
        var promoIndex: Int = 0
        //Loops through every claimed promo
        for promo in ActiveUser.activeUser.myPromos {
            //Once the promo which needs to be removed is found
            if promo?.promoID == id {
                //It is removed from the active users promo list
                ActiveUser.activeUser.myPromos.remove(at: promoIndex)
                break
            }
            promoIndex += 1
        }
        //Then it is also removed form Firebase
        DatabaseManager.shared.removeClaimedPromo(with: id)
    }
    
    ///Keeps count of the number of claimed promos
    mutating func promoClaimed() {
        self.totalPromosDone += 1
       // DatabaseManager.shared.uploadUser(user: self)
    }
    
    ///Clears locally stored promos
    mutating func clearLocalPromos() {
        self.myPromos = []
        }
    
    /// Signs user out of Firebase Auth
    func signOut() {
        do {
            try Auth.auth().signOut()
            ActiveUser.activeUser = User()
        } catch let error as NSError {
            print(error)
        }
    }
    
    ///Delete user data in Firebase Firestore
    mutating func deleteData() {
        guard let email = Auth.auth().currentUser?.email else {
            print("User ID could not be found")
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error retrieving current user")
            return
        }
        
        let db = DatabaseManager.shared.db
        let storage = Storage.storage().reference()
        
        DatabaseManager.shared.getClaimedPromoCount { count in
            guard let count = count else {return}
            for i in 0 ..< count {
                db.collection(email).document("claimedPromo\(i)").delete { error in
                    if let e = error {
                        print("Error deleting docs: \(e)")
                    } else {
                    }
                }
            }
            db.collection(email).document("details").delete()
        }
        
        //Deleting users profile picture from Firebase Storage
        let photoRef = storage.child("ProfilePics/\(userID).jpeg")
        photoRef.delete { error in
            if let error = error {
                print("Error in deleting account: \(error)")
            }
        }
    }
}

struct DataThisMonth {
    
    var numberOfLowLevelDiscountClaimed: Int = 0
    var numberOfMidLevelDiscountClaimed: Int = 0
    var numberOfHighLevelDiscountClaimed: Int = 0
    var totalNumberOfPromotions: Int = 0
    
    init() {
        self.numberOfLowLevelDiscountClaimed = 0
        self.numberOfHighLevelDiscountClaimed = 0
        self.numberOfMidLevelDiscountClaimed = 0
        self.totalNumberOfPromotions = numberOfLowLevelDiscountClaimed + numberOfMidLevelDiscountClaimed + numberOfHighLevelDiscountClaimed
    }
    
    enum CodingKeys: String, CodingKey {
        case numberOfLowLevelDiscountClaimed = "numberOfLowLevelDiscountClaimed"
        case numberOfMidLevelDiscountClaimed = "numberOfMidLevelDiscountClaimed"
        case numberOfHighLevelDiscountClaimed = "numberOfHighLevelDiscountClaimed"
        case totalNumberOfPromotions = "totalNumberOfPromotions"
    }
}

extension DataThisMonth: Encodable, Decodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(numberOfLowLevelDiscountClaimed, forKey: .numberOfLowLevelDiscountClaimed)
        try val.encode(numberOfMidLevelDiscountClaimed, forKey: .numberOfMidLevelDiscountClaimed)
        try val.encode(numberOfHighLevelDiscountClaimed, forKey: .numberOfHighLevelDiscountClaimed)
        try val.encode(totalNumberOfPromotions, forKey: .totalNumberOfPromotions)
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        numberOfLowLevelDiscountClaimed = try value.decode(Int.self, forKey: .numberOfLowLevelDiscountClaimed)
        numberOfMidLevelDiscountClaimed = try value.decode(Int.self, forKey: .numberOfMidLevelDiscountClaimed)
        numberOfHighLevelDiscountClaimed = try value.decode(Int.self, forKey: .numberOfHighLevelDiscountClaimed)
        totalNumberOfPromotions = try value.decode(Int.self, forKey: .totalNumberOfPromotions)
    }
}

struct StudentPromos {
    var businessID: String
    var promoName: String
    var discount: Int
    var isClaimed: Bool
    var storyID: [String]
    var storyCount: Int
    var totalEngagements: Int
  //  var ExpireDate : String
    
    enum CodingKeys: String, CodingKey {
        case businessID = "businessID"
        case promoName = "promoIndex"
        case discount = "discount"
        case isClaimed = "isClaimed"
        case storyID = "storyID"
        case storyCount = "storyCount"
        case totalEngagements = "totalEngagements"
       // case ExpireDate = "ExpireDate"
    }
}

extension StudentPromos: Encodable, Decodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(businessID, forKey: .businessID)
        try val.encode(promoName, forKey: .promoName)
        try val.encode(discount, forKey: .discount)
        try val.encode(isClaimed, forKey: .isClaimed)
        try val.encode(storyID, forKey: .storyID)
        try val.encode(storyCount, forKey: .storyCount)
        try val.encode(totalEngagements, forKey: .totalEngagements)
      //  try val.encode(ExpireDate, forKey: .ExpireDate)
        
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        businessID = try value.decode(String.self, forKey: .businessID)
        promoName = try value.decode(String.self, forKey: .promoName)
        discount = try value.decode(Int.self, forKey: .discount)
        isClaimed = try value.decode(Bool.self, forKey: .isClaimed)
        storyID = try value.decode([String].self, forKey: .storyID)
        storyCount = try value.decode(Int.self, forKey: .storyCount)
        totalEngagements = try value.decode(Int.self, forKey: .totalEngagements)
       // ExpireDate = try value.decode(String.self, forKey: .ExpireDate)
    }
}

extension User: Encodable, Decodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(accountStatus, forKey: .accountStatus)
        try val.encode(name, forKey: .name)
        try val.encode(urlString, forKey: .urlString)
        try val.encode(email, forKey: .email)
        try val.encode(dataThisMonth, forKey: .dataThisMonth)
        try val.encode(promos, forKey: .promos)
    }
    
    init(from decoder: Decoder) throws {
        var value = try decoder.container(keyedBy: CodingKeys.self)
        accountStatus = try value.decode(Int.self, forKey: .accountStatus)
        name = try value.decode(String.self, forKey: .name)
        urlString = try value.decode(String.self, forKey: .urlString)
        email = try value.decode(String.self, forKey: .email)
        dataThisMonth = try value.decode(DataThisMonth.self, forKey: .dataThisMonth)
        promos = try value.decode([StudentPromos].self, forKey: .promos)
        totalPromosDone = try value.decode(Int.self, forKey: .totalPromosDone)
        totalEngagements = try value.decode(Int.self, forKey: .totalEngagements)
        myPromos = []
        profilePhoto = nil
        password = ""
    }
}

class ActiveUser {
    static var activeUser = User()
}

extension Date {
    func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            return df.string(from: self)
    }
}
