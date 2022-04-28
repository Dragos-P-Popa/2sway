//
//  PromoBrain.swift
//  progressBar2
//
//  Created by user201027 on 8/7/21.
//

import Foundation

class PromoBrain {
    
    func buildSamplePromoList(from brand: Brand) -> [Promo]? {
        var promos: [Promo] = [Promo(promoID: "\(brand.brandID)-promo1", promoBrand: brand, promoTitle: "My Promo 1", promoDescription: "My Promotion 1 description", RRP: 15, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 100, midViews: 200, highViews: 300)]
        promos.append(Promo(promoID: "\(brand.brandID)-promo2", promoBrand: brand, promoTitle: "My Promo 2", promoDescription: "My Promotion 2 description", RRP: 15, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 100, midViews: 200, highViews: 300))
        promos.append(Promo(promoID: "\(brand.brandID)-promo3", promoBrand: brand, promoTitle: "My Promo 3", promoDescription: "My Promotion 3 description", RRP: 15, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 100, midViews: 200, highViews: 300))
        
        return promos
    }
    
    func buildPromoList(from brand: Brand) -> [Promo]? {
        switch brand.brandID {
        case "NAM":
            let promos: [Promo] = [
                Promo(promoID: "NAM-BAG", promoBrand: brand, promoTitle: "Baguettes", promoDescription: "Pick any of our delicious baguettes from the lunch menu and get up to 20% off!", RRP: 8.45, lowDiscountPerc: 10, midDiscountPerc: 15, highDiscountPerc: 20, lowViews: 57, midViews: 85, highViews: 113),
                Promo(promoID: "NAM-COC", promoBrand: brand, promoTitle: "Cocktails", promoDescription: "Choose a cocktail from the menu!", RRP: 8.50, lowDiscountPerc: 10, midDiscountPerc: 15, highDiscountPerc: 20, lowViews: 57, midViews: 85, highViews: 114),
                Promo(promoID: "NAM-BUN", promoBrand: brand, promoTitle: "Bun", promoDescription: "Nam Song bun description", RRP: 11.75, lowDiscountPerc: 10, midDiscountPerc: 15, highDiscountPerc: 20, lowViews: 79, midViews: 118, highViews: 158),
                Promo(promoID: "NAM-NOO", promoBrand: brand, promoTitle: "Noodle Soup", promoDescription: "Nam Song Noodle Soup description", RRP: 11.95, lowDiscountPerc: 10, midDiscountPerc: 15, highDiscountPerc: 20, lowViews: 80, midViews: 120, highViews: 148),
                Promo(promoID: "NAM-COF", promoBrand: brand, promoTitle: "Coffee", promoDescription: "Nam Song Coffee description", RRP: 4.75, lowDiscountPerc: 10, midDiscountPerc: 15, highDiscountPerc: 20, lowViews: 32, midViews: 48, highViews: 64)
            ]
            return promos
            
        case "ROL":
            let promos: [Promo] = [
            Promo(promoID: "ROL-ALL", promoBrand: brand, promoTitle: "Any item on the menu", promoDescription: "There is a minimum spend of £10 to use this discount", RRP: 10, lowDiscountPerc: 20, midDiscountPerc: 30, highDiscountPerc: 40, lowViews: 200, midViews: 300, highViews: 400)
            ]
            return promos
            
        case "PIX":
            let promos: [Promo] = [
                Promo(promoID: "PIX-SHO", promoBrand: brand, promoTitle: "Any shot x4", promoDescription: "", RRP: 24.0, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 320, midViews: 640, highViews: 920),
                Promo(promoID: "PIX-DUB", promoBrand: brand, promoTitle: "Double house spirit & mixer x2", promoDescription: "", RRP: 13.0, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 320, midViews: 640, highViews: 960),
                Promo(promoID: "PIX-POT", promoBrand: brand, promoTitle: "Any potion shot x3", promoDescription: "", RRP: 9.0, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 120, midViews: 240, highViews: 360),
                Promo(promoID: "PIX-BOB", promoBrand: brand, promoTitle: "Any BOB-OMBS x2", promoDescription: "", RRP: 9.0, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 120, midViews: 240, highViews: 360),
                Promo(promoID: "PIX-PIT", promoBrand: brand, promoTitle: "Any pitcher", promoDescription: "", RRP: 18.0, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 240, midViews: 480, highViews: 720)
            ]
            return promos
            
        case "YAC":
            let promos: [Promo] = [
            Promo(promoID: "YAC-ALL", promoBrand: brand, promoTitle: "Any item on the menu", promoDescription: "There is a minimum spend of £10 to use this discount", RRP: 10, lowDiscountPerc: 20, midDiscountPerc: 40, highDiscountPerc: 60, lowViews: 134, midViews: 267, highViews: 400)
            ]
            return promos
        default:
            return nil
        }
    }
    
    func getPromoFromID(brandID: String, promoID: String) -> Promo? {
        guard let brand = BrandBrain().getBrandFromID(brandID: brandID) else { return nil }
        guard let promos = PromoBrain().buildPromoList(from: brand) else {
            print("Couldn't get promos")
            return nil
        }
        for promo in promos {
            if promo.promoID == promoID {
                return promo
            }
        }
        print("Promo: \(promoID) could not be found")
        return nil
    }
}
