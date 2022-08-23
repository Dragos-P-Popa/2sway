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
    var business: Business? = nil
    
    @State var isCompleted: Int = 0
    @State var errorMessage: String = ""
    
    @ViewBuilder
    var body: some View {
        if self.isCompleted == 1 {
            RedeemView(business: business, isCompleted: self.$isCompleted)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.easeInOut))
        } else if self.isCompleted < 0{
            ErrorViewController(errorTitle: "ERROR", errorDescription: "Error code: \(self.isCompleted)", buttonText: "RETRY")
        }
        else {
            StoryLoadingView(business: business, isCompleted: self.$isCompleted /*, errorMessage: self.$errorMessage*/)
        }
    }
}


struct StoryLoadingView: View {
    var business: Business? = nil
    @Binding var isCompleted: Int
    //@Binding var errorMessage: String
    var checkerClass = storyCompletionChecker()
    
    var body: some View {
        
        VStack{
            Spacer()
                .frame(height: 80)
                .frame(maxWidth: .infinity)
            Text("Checking your story...")
                .fontWeight(.black)
                .foregroundColor(.white)
                .font(.custom("Jost", size: 32))
                .multilineTextAlignment(.center)
            Spacer()
            Image("cherry-search")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
            Text("Ensure you’ve included the restaurant’s location tag on your story")
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .font(.custom("Jost", size: 23))
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
        }.background(
            Color.black
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear(perform: verifyStory)
                    
    }
    
    func delayView(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isCompleted = 1
            }
    }
    
    func verifyStory(){
        self.checkerClass.checkStory(business: business!) { result in
            print(result)
            self.isCompleted = result
            //self.errorMessage =
        }
    }
}

class storyCompletionChecker {
    // Completing method
    // Here would be your code that would "complete" true if successfully logged in or false if error

    func checkStory(business: Business, completion: @escaping (Int) -> Void) {
        @ObservedObject var monitor = NetworkMonitor()
        let localUrl = "http://77.68.72.78/story/"
        let apiClas = APIClient()
        
        var EmailMain = String()
        var EmailMain1 = String()
        if let email = UserDefaults.standard.object(forKey:K.udefalt.EmailCurrent) {
            EmailMain = "\(email)"
        } else {
            EmailMain = ""
        }
        if let UserIdMain = UserDefaults.standard.object(forKey:K.udefalt.UserIdMain) {
            EmailMain1 = "\(UserIdMain)"
        } else {
            EmailMain1 = K.userID ?? ""
        }
        let businessName = business.name.capitalized
        let parameters = [
            "userId":EmailMain1,
            "coockies":K.cookieString ?? "", "email":EmailMain, "businessId":businessName
        ] as [String : Any]
        print(parameters)
        var urlString = String()
        urlString = localUrl + "getStories.php"
        
        
        apiClas.getStoryCount1(urlMain:urlString, parametersInsta:parameters) { sCount, SIds,instaId,isExpire   in
            if sCount == "-1" {
                completion(Int(sCount)!)
            } else if sCount == "-2" {
                completion(Int(sCount)!)
            } else {
                completion(1)
            }
        } fail: { error in
            print(error.debugDescription)
            completion(-3)
        }
    }
    
}

struct RedeemView: View {
    //var dismissAction: (() -> Void)
    var business: Business? = nil
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @Binding var isCompleted: Int
    
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
            
            ZStack{
                
                RoundedRectangle(cornerRadius: 14.0)
                    .frame(width: .infinity, height: 400.0)
                    .shiny(.matte(.black))
                    .padding()
                
                VStack {
                    Spacer()
                        .frame(height: 50)
                    VStack {
                        Text("\(business!.discounts[Int(AppData.shared.user!.tier)-1])%")
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
