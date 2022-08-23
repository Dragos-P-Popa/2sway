//
//  OnboardingCard.swift
//  2Sway
//
//  Created by Dragos Popa on 21/07/2022.
//

import Foundation

struct OnboardingCard: Identifiable {
    var id = UUID()
    var title:String
    var image:String
}

var testData:[OnboardingCard] = [
    OnboardingCard(title: "Post a photo on your story", image: "cherry-story"),
    OnboardingCard(title: "Tag the location of the restaurant you are at", image: "urban-label"),
    OnboardingCard(title: "Claim your discount", image: "cherry-payment-processed")
]
