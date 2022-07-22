//
//  LoadingViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 22/07/2022.
//

import Foundation
import SwiftUI

struct LoadingViewController: View {
    @State var loadingTitle: String
    @State var loadingDescription: String
    @State var image: String
    
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 80)
                .frame(maxWidth: .infinity)
            Text(loadingTitle)
                .fontWeight(.black)
                .foregroundColor(.white)
                .font(.custom("Jost", size: 32))
                .multilineTextAlignment(.center)
            Spacer()
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
            Spacer()
                .frame(height: 50)
            Text(loadingDescription)
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

struct LoadingViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoadingViewController(loadingTitle: "Fetching your bill...", loadingDescription: "2Sway automatically tries to add all the available offers to your bill in order to reach the lowest possible price!", image: "cherry-664")
    }
}
