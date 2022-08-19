//
//  RedeemViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 17/08/2022.
//

import Foundation
import SwiftUI
import Shiny

struct RedeemViewController: View {
    @State private var showSplash = true
    var business: Business? = nil
    
    var body: some View {
        Group {
            if showSplash {
                StoryLoadingView()
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.easeInOut))
            } else {
                RedeemView(business: business)
                    //.animation(.easeIn(duration: 10))
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.easeInOut))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showSplash = false
            }
        }
    }
}

struct RedeemView: View {
    //var dismissAction: (() -> Void)
    var business: Business? = nil
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var body: some View {
        VStack{
            
            Spacer()
            
            ZStack{
                
                RoundedRectangle(cornerRadius: 14.0)
                    .frame(width: .infinity, height: 400.0)
                    .shiny(.matte(.black))
                    .padding()
                
                VStack {
                    Spacer()
                        .frame(height: 50)
                    VStack {
                        Text("\(business!.highestDiscount)%")
                            .font(.custom("Jost", size: 52))
                            .fontWeight(.heavy).shiny(.iridescent)
                            
                        Text("DISCOUNT")
                            .font(.custom("Jost", size: 32))
                            .fontWeight(.heavy).shiny(.iridescent)
                    }
                    
                    Spacer()
                        .frame(height: 100)
                    
                    Text("Tier \(AppData.shared.user!.tier)")
                        .font(.custom("Jost", size: 46))
                        .fontWeight(.heavy).shiny(.iridescent)
                    Text("\(AppData.shared.user?.name ?? "Invalid") | \(AppData.shared.user?.email ?? "Invalid@email.com")")
                        .font(.custom("Jost", size: 16))
                        .fontWeight(.regular).shiny(.iridescent)
                }
                
            }.shadow(radius: 5)
            
            
            
            Spacer()
            Button(action: {/*self.selection = 1*/}) {
                Text("DONE")
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
        .padding()
        .cornerRadius(35)
        .background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    struct RedeemViewController_Previews: PreviewProvider {
        static var previews: some View {
            RedeemViewController()
        }
    }
}
