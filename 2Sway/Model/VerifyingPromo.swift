//
//  VerifyingPromo.swift
//  2Sway
//
//  Created by Joe Feest on 23/09/2021.
//

import Foundation

class VerifyingPromo: Codable {
    
    let brandID: String
    let promoID: String
    let isOkay: Bool
    
    init(brandID: String, promoID: String) {
        self.brandID = brandID
        self.promoID = promoID
        self.isOkay = true
    }
}
