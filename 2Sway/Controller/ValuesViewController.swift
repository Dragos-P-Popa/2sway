//
//  ValuesViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 07/08/2022.
//

import Foundation
import SwiftUI

struct ValuesViewController: View {
    var dismissAction: (() -> Void)
    @State var selectedPage:Int = 0
    @State var buttonText = "CONTINUE"
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
        @State private var counter = 0
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 50)
            TabView(selection: $selectedPage) {
                ForEach(0..<testData.count) { index in
                    ValuesView(card: valuesData[index]).tag(index)
                }
                
            }.background(
                Color.black
                    .edgesIgnoringSafeArea(.all)
            )
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Spacer()
                .frame(height: 60)
                .onReceive(timer) { time in
                                if counter == 2 {
                                    timer.upstream.connect().cancel()
                                } else {
                                    selectedPage = selectedPage + 1
                                }

                                counter += 1
                            }
            
            Button(action: dismissAction) {
                    Text(buttonText)
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
                
        }.background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    /*struct ValuesViewController_Previews: PreviewProvider {
        static var previews: some View {
            ValuesViewController()
        }
    }
     */
}
