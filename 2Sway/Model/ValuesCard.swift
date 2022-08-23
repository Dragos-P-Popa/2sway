//
//  ValuesCard.swift
//  2Sway
//
//  Created by Dragos Popa on 01/08/2022.
//

import Foundation

struct ValuesCard: Identifiable {
    var id = UUID()
    var title:String
    var description:String
    var image:String
}

var valuesData:[ValuesCard] = [
    ValuesCard(title: "Exclusive discounts at restaurants across London", description: "We reward creators for supporting restaurants through sharing their experiences", image: "cherry-story"),
    ValuesCard(title: "Capture the moment", description: "Share a photo or video at the restaurant on your Instagram story to help promote the venue", image: "urban-label"),
    ValuesCard(title: "Pay a discounted price in-app", description: "Share a photo or video at the restaurant on your Instagram story to help promote the venue", image: "cherry-payment-processed")
]
