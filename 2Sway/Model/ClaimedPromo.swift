//
//  ClaimedPromo.swift
//  progressBar2
//
//  Created by Joe Feest on 17/08/2021.
//

import Foundation

class ClaimedPromo: Promo {
    let claimedPromo: Promo
    let timeClaimed: Date
    var isRedeemed: Bool
    var timeRedeemed: Date?      // optional because this attribute is added after class is initialised
    let percentageOff: Int
    let discountCode: String
    
    
    init(claimedPromo: Promo, timeClaimed: Date, percentageOff: Int, discountCode: String) {
        self.claimedPromo = claimedPromo
        self.timeClaimed = timeClaimed
        self.isRedeemed = false
        self.percentageOff = percentageOff
        self.discountCode = discountCode
        super.init(promoID: claimedPromo.promoID, promoBrand: claimedPromo.promoBrand, promoTitle: claimedPromo.promoTitle, promoDescription: claimedPromo.promoDescription, RRP: claimedPromo.RRP, lowDiscountPerc: claimedPromo.lowDiscountPerc, midDiscountPerc: claimedPromo.midDiscountPerc, highDiscountPerc: claimedPromo.highDiscountPerc, lowViews: claimedPromo.lowViews, midViews: claimedPromo.midViews, highViews: claimedPromo.highViews)
    }
    
    init(claimedPromo: Promo, timeClaimed: Date, isRedeemed: Bool, timeRedeemed: Date, percentageOff: Int, discountCode: String) {
        self.claimedPromo = claimedPromo
        self.timeClaimed = timeClaimed
        self.isRedeemed = isRedeemed
        self.timeRedeemed = timeRedeemed
        self.percentageOff = percentageOff
        self.discountCode = discountCode
        super.init(promoID: claimedPromo.promoID, promoBrand: claimedPromo.promoBrand, promoTitle: claimedPromo.promoTitle, promoDescription: claimedPromo.promoDescription, RRP: claimedPromo.RRP, lowDiscountPerc: claimedPromo.lowDiscountPerc, midDiscountPerc: claimedPromo.midDiscountPerc, highDiscountPerc: claimedPromo.highDiscountPerc, lowViews: claimedPromo.lowViews, midViews: claimedPromo.midViews, highViews: claimedPromo.highViews)
    }
    
    func timeRemainingToRedeem() -> TimeInterval {
        let timeRemaining: TimeInterval = K.promoAvailableDays*86400 - Date().timeIntervalSince(timeClaimed)
        return timeRemaining
    }
    
    func formatAdaptiveTimeRemaining(timeRemaining: TimeInterval) -> String? {
        if timeRemaining > 86400 {          // More than 1 day remaining
            return timeRemainingToRedeem().format(using: [.day, .hour])
        }
        else if timeRemaining > 3600 {      // 1hr - 1 day remaining
            return timeRemainingToRedeem().format(using: [.hour, .minute])

        }
        else if timeRemaining > 60 {        // 1 min - 1 hr remaining
            return timeRemainingToRedeem().format(using: [.minute, .second])
        }
        else {
            return timeRemainingToRedeem().format(using: [.second])

        }
    }
    
    func timeRemainingWithCode() -> TimeInterval? {
            
        guard let timeRedeemed = self.timeRedeemed else {
            print("Error calculating time redeemed")
            return nil
        }
        let timeRemaining: TimeInterval = K.codeDuration - Date().timeIntervalSince(timeRedeemed)
        return timeRemaining
    }
    
}
