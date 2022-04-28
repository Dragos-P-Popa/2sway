//
//  Promo.swift
//  progressBar2
//
//  Created by user201027 on 8/7/21.
//

import Foundation
import UIKit

class Promo: Brand {
    let promoID: String
    let promoBrand: Brand
    let promoTitle: String
    let promoDescription: String
    let RRP: Float
    let lowDiscountPerc: Int
    let midDiscountPerc: Int
    let highDiscountPerc: Int
    let lowViews: Int
    let midViews: Int
    let highViews: Int
    let lowDiscountCode: String = "LOCODE"
    let midDiscountCode: String = "MIDCODE"
    let highDiscountCode: String = "HICODE"
    var specificDiscount: Int?

    init(promoID: String, promoBrand: Brand, promoTitle: String, promoDescription: String, RRP: Float, lowDiscountPerc: Int, midDiscountPerc: Int, highDiscountPerc: Int, lowViews: Int, midViews: Int, highViews: Int) {
        self.promoID = promoID
        self.promoBrand = promoBrand
        self.promoTitle = promoTitle
        self.promoDescription = promoDescription
        self.RRP = RRP
        self.lowDiscountPerc = lowDiscountPerc
        self.midDiscountPerc = midDiscountPerc
        self.highDiscountPerc = highDiscountPerc
        self.lowViews = lowViews
        self.midViews = midViews
        self.highViews = highViews
        super.init(brandID: promoBrand.brandID, name: promoBrand.brandName, desc: promoBrand.brandDesc, maxDiscount: highDiscountPerc, brandImage: promoBrand.brandImage)
    }

    func getSpecificDiscount(claimedViews: Int) {
        
        if claimedViews < lowViews {
            self.specificDiscount = 0
        } else if claimedViews < midViews {
            self.specificDiscount = lowDiscountPerc
        } else if claimedViews < highViews {
            self.specificDiscount = midDiscountPerc
        } else {
            self.specificDiscount = highDiscountPerc
        }
    }
//    var claimedViews: Int = 0
//    var specificDiscount: Int {
//        get {
//            if claimedViews < lowViews {
//                return 0
//            } else if claimedViews < midViews {
//                return lowDiscountPerc
//            } else if claimedViews < highViews {
//                return midDiscountPerc
//            } else {
//                return highDiscountPerc
//            }
//        }
//    }
    
    func createVerifyingPromo() -> VerifyingPromo {
        return VerifyingPromo(brandID: self.brandID, promoID: promoID)
    }
}
