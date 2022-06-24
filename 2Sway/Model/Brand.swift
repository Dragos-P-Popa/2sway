//
//  Brand.swift
//  progressBar2
//
//  Created by Joe Feest on 26/07/2021.
//

import Foundation
import UIKit

class Brand {
    let brandID: String
    let brandName: String
    let brandDesc: String
    var maxDiscount: Int
    let brandImage: UIImage
    
    init(brandID: String, name: String, desc: String, maxDiscount: Int, brandImage: UIImage)  {
        self.brandID = brandID
        self.brandName = name
        self.brandDesc = desc
        self.maxDiscount = maxDiscount
        self.brandImage = brandImage
    }
    
    ///Updates brand analytics in Firebase Firestore
    func brandPromoClaimed() {
        print("Brand promo claimed called")
        getBrandPromosCount { oldCount in
            let newCount = oldCount + 1
            let brandStats = BrandStats(brandID: self.brandID, brandName: self.brandName, totalPromos: newCount)
            brandStats.uploadBrandData()
        }
    }
    
    ///Retrieves number of promos for a certain brand
    func getBrandPromosCount(completion: @escaping (Int) -> Void) {
        
        DatabaseManager.shared.db.collection(self.brandID).document("details").getDocument { document, error in
            if let e = error {
                print("Error getting brand details doc: \(e)")
                return
            } else {
                let result = Result {
                    try document?.data(as: BrandStats.self)
                }
                switch result {
                case .success(let brandStats):
                    if let brandStats = brandStats {
                        // A `brandStats` value was successfully initialized from the DocumentSnapshot.
                        completion(brandStats.totalPromos)
                        
                    } else {
                        // a nil value was successfully initialised from the snapshot
                        // or the snapshot was nil
                        print("brand details document doesn't Exist1")
                        completion(0)
                    }
                case .failure(let error):
                    // A CodableClaimedPromo could not be initialised from the snapshot
                    print("Error decoding city: \(error)")
                }
            }
        }
    }
}
