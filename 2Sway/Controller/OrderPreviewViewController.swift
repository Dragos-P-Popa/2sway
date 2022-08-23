//
//  OrderPreviewViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 05/08/2022.
//

import SwiftUI

struct OrderPreviewViewController: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                BillLoadingView()
            } else {
                OrderPreviewView(table: "Table 12", restaurant: "Rola Wala", discount: "―£10.99", orderItems: [["Item 1", "£10.99"],["Item 2", "2 X £12.95"],["Item 3", "4 X £4.95"],["Item 4", "£10.95"]])
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showSplash = false
            }
        }
    }
}
    
struct OrderPreviewView: View {
    let table: String
    let restaurant: String
    let discount: String
    let orderItems: [[String]]
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
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
                    
                    
                    Text("Your table")
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .font(.custom("Jost", size: 28))
                    
                    Spacer()
                    
                    CardView(heading: table, subHeading: restaurant, rowItems: orderItems)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Your discount")
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .font(.custom("Jost", size: 28))
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(hex: 0x1D1D1B))
                        
                        VStack(alignment: .leading){
                            Text(discount)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .font(.custom("Jost", size: 28))
                                .padding()
                        }
                    }
                    
                    Group {
                        HStack{
                            Image(systemName: "info.circle.fill")
                            Text("Deleting your story early will result in a penalty to your tier.")
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .font(.custom("Jost", size: 10))
                        }.padding(.leading, 5)
                    }
                    
                    NavigationLink(destination: OrderViewController().navigationBarBackButtonHidden(true), tag: 1, selection: $selection) {
                        Button(action: {self.selection = 1}) {
                            Text("I'VE POSTED")
                                .fontWeight(.black)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.custom("Jost", size: 22))
                                .padding(8)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 35)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(35)
                    }
                }
                .padding()
                
            }.background(
                Color.black
                    .edgesIgnoringSafeArea(.all)
            )
            .preferredColorScheme(.dark)
        }
    }
}
    
struct BillLoadingView: View {
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 80)
                .frame(maxWidth: .infinity)
            Text("Fetching your bill...")
                .fontWeight(.black)
                .foregroundColor(.white)
                .font(.custom("Jost", size: 32))
                .multilineTextAlignment(.center)
            Spacer()
            Image("cherry-664")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
            Spacer()
                .frame(height: 50)
            Text("2Sway automatically tries to add all the available offers to your bill in order to reach the lowest possible price!")
                .fontWeight(.medium)
                .foregroundColor(.white)
                .font(.custom("Jost", size: 22))
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
                .frame(height: 50)
            
        }.background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

 struct OrderPreviewViewController_Previews: PreviewProvider {
     static var previews: some View {
         BillLoadingView()
         OrderPreviewView(table: "Table 12", restaurant: "Rola Wala", discount: "―£10.99", orderItems: [["Item 1", "£10.99"],["Item 2", "2 X £12.95"],["Item 3", "4 X £4.95"],["Item 4", "£10.95"]])
         // ―
     }
 }
 
