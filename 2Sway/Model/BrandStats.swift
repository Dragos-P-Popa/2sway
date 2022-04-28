//
//  BrandStats.swift
//  2Sway
//
//  Created by Joe Feest on 23/09/2021.
//

import Foundation

class BrandStats: Codable {
    
    let brandID: String
    let brandName: String
    let totalPromos: Int
    
    init(brandID: String, brandName: String, totalPromos: Int) {
        self.brandID = brandID
        self.brandName = brandName
        self.totalPromos = totalPromos
    }
    
    func uploadBrandData() {
        
        print("Uploading Brand details")
        
        do {
            try DatabaseManager.shared.db.collection(self.brandID).document("details").setData(from: self)
        } catch let error {
            print("Error writing promo to firestore: \(error)")
        }
    }
}
