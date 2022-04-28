//
//  CodableClaimedPromo.swift
//  2Sway
//
//  Created by Joe Feest on 22/09/2021.
//

import Foundation

public class CodableClaimedPromo: Codable {
    
    let promoID: String
    let brandID: String
    let timeClaimed: Date
    var isRedeemed: Bool
    var timeRedeemed: Date?
    let percentageOff: Int
    let discountCode: String
    
    init(promoID: String, brandID: String, timeClaimed: Date, percentageOff: Int, discountCode: String) {
        self.promoID = promoID
        self.brandID = brandID
        self.timeClaimed = timeClaimed
        self.isRedeemed = false
        self.percentageOff = percentageOff
        self.discountCode = discountCode
    }
    
    init(promoID: String, brandID: String, timeClaimed: Date, isRedeemed: Bool, timeRedeemed: Date, percentageOff: Int, discountCode: String) {
        self.promoID = promoID
        self.brandID = brandID
        self.timeClaimed = timeClaimed
        self.isRedeemed = isRedeemed
        self.timeRedeemed = timeRedeemed
        self.percentageOff = percentageOff
        self.discountCode = discountCode
    }
    
    func createClaimedPromo() -> ClaimedPromo? {
        if self.isRedeemed == false {
            guard let promo = PromoBrain().getPromoFromID(brandID: self.brandID,
                                                          promoID: self.promoID) else {
                return nil
            }
            let claimedPromo = ClaimedPromo(claimedPromo: promo,
                                            timeClaimed: self.timeClaimed,
                                            percentageOff: self.percentageOff,
                                            discountCode: self.discountCode)
            return claimedPromo
        } else {
            
            guard let promo = PromoBrain().getPromoFromID(brandID: self.brandID,
                                                          promoID: self.promoID) else {
                return nil
            }
            let claimedPromo = ClaimedPromo(claimedPromo: promo,
                                            timeClaimed: self.timeClaimed,
                                            isRedeemed: self.isRedeemed,
                                            timeRedeemed: self.timeRedeemed!,
                                            percentageOff: self.percentageOff,
                                            discountCode: self.discountCode)
            return claimedPromo
        }
    }
}
