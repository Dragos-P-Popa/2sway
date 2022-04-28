//
//  User.swift
//  progressBar2
//
//  Created by Abhishek Dubey on 24/01/2022.
//

import Foundation
import UIKit
import Firebase

struct UserModel {
    
    var email: String?
    var name: String?
    var isExpire : String?
    var urlString: String?
    var dataThisMonth: DataThisMonth
 //   var totalPromosDone: Int
    var totalEngagements: Int
    var promos: [StudentPromos]
    var instagram: String
    var storyIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case urlString = "urlString"
        case name = "name"
        case isExpire = "isExpire"
        case dataThisMonth = "dataThisMonth"
        case totalEngagements
        case promos
        case instagram
        case storyIds
     //   case totalPromosDone
    }
        
    func removeClaimedPromo(id: String) {
        var promoIndex: Int = 0
        for promo in ActiveUser.activeUser.myPromos {
            if promo?.promoID == id {
                ActiveUser.activeUser.myPromos.remove(at: promoIndex)
                break
            }
            promoIndex += 1
        }
         DatabaseManager.shared.removeClaimedPromo(with: id)
    }
    
    // Sign out from firebase
    func signOut() {
        do {
            try Auth.auth().signOut()
            ActiveUser.activeUser = User()
        } catch let error as NSError {
            print(error)
        }
    }
    
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
        
        let photoRef = storage.child("ProfilePics/\(userID).jpeg")
        photoRef.delete { error in
            if let error = error {
                print("Error in deleting account: \(error)")
            }
        }
    }
}

extension UserModel: Encodable, Decodable {
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(name, forKey: .name)
        try val.encode(urlString, forKey: .urlString)
        try val.encode(email, forKey: .email)
        try val.encode(isExpire, forKey: .isExpire)
        try val.encode(dataThisMonth, forKey: .dataThisMonth)
        try val.encode(promos, forKey: .promos)
        try val.encode(totalEngagements, forKey: .totalEngagements)
        try val.encode(instagram, forKey: .instagram)
        try val.encode(storyIds, forKey: .storyIds)
    }
    
    init(from decoder: Decoder) throws {
        var value = try decoder.container(keyedBy: CodingKeys.self)
        name = try value.decode(String.self, forKey: .name)
        isExpire = try value.decode(String.self, forKey: .isExpire)
        urlString = try value.decode(String.self, forKey: .urlString)
        email = try value.decode(String.self, forKey: .email)
        dataThisMonth = try value.decode(DataThisMonth.self, forKey: .dataThisMonth)
        promos = try value.decode([StudentPromos].self, forKey: .promos)
    //    totalPromosDone = try value.decode(Int.self, forKey: .totalPromosDone)
        totalEngagements = try value.decode(Int.self, forKey: .totalEngagements)
        instagram = try value.decode(String.self, forKey: .instagram)
        storyIds = try value.decode([String].self, forKey: .storyIds)
    }
}
