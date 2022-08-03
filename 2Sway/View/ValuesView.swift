//
//  ValuesView.swift
//  2Sway
//
//  Created by Dragos Popa on 01/08/2022.
//

import Foundation
import SwiftUI

struct ValuesView: View {
    
    var card:ValuesCard
    
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
                .font(.custom("Jost", size: 28))
            Spacer()
                .frame(height: 25)
            Text(card.description)
                .fontWeight(.black)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.custom("Jost", size: 16))
            Spacer()
        }.padding()
         .background(Color.black)
    }
    
    struct ValuesCard_Previews: PreviewProvider {
        static var previews: some View {
            ValuesView(card: valuesData[0])
        }
    }
}
