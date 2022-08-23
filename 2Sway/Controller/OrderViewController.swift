//
//  OrderViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 06/08/2022.
//


import SwiftUI

struct OrderViewController: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                //StoryLoadingView()
            } else {
                OrderView(table: "Table 12", restaurant: "Rola Wala", discount: "―£10.99", purchaseBreakdown: [["Item 1", "£10.99"],["Item 2", "2 X £12.95"],["Item 3", "4 X £4.95"],["Item 4", "£10.95"]])
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showSplash = false
            }
        }
    }
}

struct OrderView: View {
    let table: String
    let restaurant: String
    let discount: String
    let purchaseBreakdown: [[String]]

    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {}) {
                        Image("leftArrowWhite")
                    }.foregroundColor(Color.white)
                    Spacer()
                        .frame(width: 15)
                    Text("Your order")
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .font(.custom("Jost", size: 38))
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                /// Manipulate discounted item price strings here
                
                DiscountedCardView(heading: "Heading", subHeading: "Subheading", rowItems: [["Row 1", "Price"],["Row 2", "Price"]])
                
                Spacer()
                    .frame(height: 20)
                
                CardView(heading: "Your bill", subHeading: restaurant, rowItems: purchaseBreakdown)
                
            

            }
            
            .padding()
        }.background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
        .preferredColorScheme(.dark)
    }
}



 struct OrderViewController_Previews: PreviewProvider {
     static var previews: some View {
         OrderView(table: "Table 12", restaurant: "Rola Wala", discount: "―£10.99", purchaseBreakdown: [["Item 1", "£10.99"],["Item 2", "2 X £12.95"],["Item 3", "4 X £4.95"],["Item 4", "£10.95"]])
         // ―
     }
 }
 
