//
//  OnboardingView.swift
//  2Sway
//
//  Created by Dragos Popa on 21/07/2022.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    
    var card:OnboardingCard
    
    var body: some View {
        VStack{
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
            Text(card.title)
                .fontWeight(.black)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }.padding()
         .background(Color.black)
         .font(.custom("Jost", size: 32))
    }
    
    struct OnboardingCard_Previews: PreviewProvider {
        static var previews: some View {
            OnboardingView(card: testData[0])
        }
    }
}
