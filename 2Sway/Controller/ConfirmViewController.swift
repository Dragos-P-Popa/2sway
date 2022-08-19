//
//  RedeemViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 17/08/2022.
//

import Foundation
import SwiftUI

struct ConfirmViewController: View {
    //var dismissAction: (() -> Void)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @State var selection: Int? = nil
    var brand: Business? = nil
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {}) {
                    Image("leftArrowWhite")
                }.foregroundColor(Color.white)
                Spacer()
                    .frame(width: 15)
                Text("Your discount")
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .font(.custom("Jost", size: 38))
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
                Image("cherry-story")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center)
                Text("Post a photo on your story, including the restaurants location tag")
                    .fontWeight(.black)
                    .font(.custom("Jost", size: 26))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
            NavigationLink(destination: RedeemViewController(business: brand).navigationBarBackButtonHidden(true), tag: 1, selection: $selection) {
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
        .cornerRadius(35)
        .background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    struct ConfirmViewController_Previews: PreviewProvider {
        static var previews: some View {
            ConfirmViewController()
        }
    }
}
