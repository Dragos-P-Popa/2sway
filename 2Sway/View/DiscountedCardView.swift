//
//  DiscountedCardView.swift
//  2Sway
//
//  Created by Dragos Popa on 06/08/2022.
//

import SwiftUI

struct DiscountedCardView: View {
    let heading: String
    let subHeading: String
    let rowItems: [[String]]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(hex: 0x1D1D1B))
            
            VStack(alignment: .leading){
                HStack {
                    VStack(alignment: .leading) {
                        Text(heading)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .font(.custom("Jost", size: 22))
                        Text(subHeading)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .font(.custom("Jost", size: 12))
                    }.padding()
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Discounted by")
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .font(.custom("Jost", size: 12))
                        
                        Spacer()
                            .frame(height:0)
                        
                        HStack{
                            Image("money")
                                .resizable()
                                .renderingMode(.template)
                               .foregroundColor(.green)
                               .frame(maxWidth: 20, maxHeight: 20)
                            Text("60%")
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .font(.custom("Jost", size: 18))
                        }
                    }.padding()
                }
                
                Divider()
                
                ForEach(0..<rowItems.count) { each in
                    HStack {
                        Text("\(rowItems[each][0])")
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .font(.custom("Jost", size: 16))
                        
                        Text("\(rowItems[each][1])")
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .font(.custom("Jost", size: 16))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }.padding()
                    if each == rowItems.count - 1 {
                        Divider()
                            .opacity(0)
                    }
                    else {
                        Divider()
                    }
                }
            }
        }
    }
}

struct DiscountedCardView_Previews: PreviewProvider {
    static var previews: some View {
        DiscountedCardView(heading: "Heading", subHeading: "Subheading", rowItems: [["Row 1", "Price"],["Row 2", "Price"]])
    }
}

