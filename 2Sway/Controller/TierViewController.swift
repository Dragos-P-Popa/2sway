//
//  TierViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 04/08/2022.
//

import SwiftUI

struct TierViewController: View {
    var dismissAction: (() -> Void)
    
    var body: some View {
        ScrollView{
            VStack {
                HStack {
                    Button(action: dismissAction) {
                    //Button(action: {}) {
                        Image("downArrowWhite")
                    }.foregroundColor(Color.white)
                    Spacer()
                        .frame(width: 15)
                    Text("Your tier")
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .font(.custom("Jost", size: 38))
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    .frame(height: 100)
                ZStack {
                    
                    CircularProgressView(progress: determineTier())
                    Text("Tier \(AppData.shared.user!.tier)")
                        .fontWeight(.black)
                        .font(.custom("Jost", size: 42))
                        .foregroundColor(.white)
                }.frame(width: 200, height: 200)
                Spacer()
                    .frame(height: 100)
                VStack(alignment: .leading, spacing: 10) {
                    
                    Collapsible(
                                    label: { Text("How your discount is calculated?")
                                            .fontWeight(.black)
                                            .foregroundColor(.white)
                                            .font(.custom("Jost", size: 28)) },
                                    content: {
                                        Text("Mention tiers. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla volutpat nibh tellus, scelerisque pharetra mi iaculis mollis. Morbi ante neque, eleifend a venenatis at, aliquam at sem. Duis eget bibendum sapien. Cras imperdiet et urna ut mattis.")
                                            .fontWeight(.regular)
                                            .foregroundColor(.white)
                                            .font(.custom("Jost", size: 20))
                                    }
                                )
                                .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Collapsible(
                                    label: { Text("Is your discount wrong?")
                                            .fontWeight(.black)
                                            .foregroundColor(.white)
                                            .font(.custom("Jost", size: 28)) },
                                    content: {
                                        Text("If you think we have calculated your discount tier wrong or you have recently seen a dramatic change in your engagemnt you can contact us at hello@2sway.co.uk or DM us on Instagram.")
                                            .fontWeight(.regular)
                                            .foregroundColor(.white)
                                            .font(.custom("Jost", size: 20))
                                    }
                                )
                                .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Button(action: {
                        if let url = URL(string: "https://www.instagram.com/2swayuk/") {
                           UIApplication.shared.open(url)
                        }
                    }) {
                            Text("DM US ON INSTAGRAM")
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
    }
    
    func determineTier() -> Double{
        let tier = AppData.shared.user!.tier
        if tier == 10{
            return 1
        }
        else{  return Double(String("0." + String(AppData.shared.user!.tier) + "00000"))!  }
    }
}

/*
 struct TierViewController_Previews: PreviewProvider {
 static var previews: some View {
 TierViewController(progress: 0.400000)
 }
 }
 */
