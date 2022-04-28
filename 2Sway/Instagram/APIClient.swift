//
//  StroyCountAPICall.swift
//  2Sway
//
//  Created by Abhishek Dubey on 06/01/22.
//

import Foundation


class APIClient {
    func getStoryCount1(urlMain:String,parametersInsta:[String:Any],success: @escaping(String, String ,[String],Bool) -> Void, fail: @escaping(Error?) -> Void) {
     //   let urlString = "http://192.168.1.123/2way/story/getStories.php"
       // let urlString = "http://77.68.72.78/story/getStories.php"
        let urlString = urlMain
         var request = URLRequest(url: URL(string:urlString)!,timeoutInterval: 60)
        print(parametersInsta)
        request.httpMethod = "POST"
        request.httpBody = parametersInsta.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            // print("API call data ", String(data: data, encoding: .utf8)!)
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                let message = json["msg"] as? String
                if message == "success" {
                    var aryCheck = NSArray()
                    let count = json as? NSDictionary
                    let count1 = json["data"] as? NSDictionary
//                    if let reelsAry = count1?.object(forKey:"reels_media") as? [String] {
//                        print("Exppire")
//                    }
                    if let reelsAry = count1?.object(forKey:"reels_media") as? NSArray {
                        aryCheck = reelsAry
                    }
                    var aryStoryCount = String()
                    var aryStoryDiscount = String()
                    var aryInstaId = [String]()
                    aryStoryCount = "\(count1?.object(forKey:"count") ?? "")"
                    aryStoryDiscount = "\(count1?.object(forKey:"discount") ?? "")"
                        // aryInstaId = "\(count1?.object(forKey:"storyID") ?? "")"
                    aryInstaId = count1?.object(forKey:"storyID") as! [String]
                    //aryStoryCount = "1245"
                   // aryStoryDiscount = "60"
                    print(aryInstaId)
                    print(aryStoryCount,aryStoryDiscount)
                    if aryCheck.count == 0 {
                        success(aryStoryCount,aryStoryDiscount,aryInstaId,true)
                    } else {
                        if aryStoryCount != "0" {
                           // success(totalSum,aryStoryIdCout.last ?? "")
                            success(aryStoryCount,aryStoryDiscount,aryInstaId,false)
                        } else {
                            success("0", "0",aryInstaId,false)
                        }
                    }
                } else {
                    success("-2",message ?? "",["1"],false)
                }
//                if message == "Do not have any story. Please upload" {
//                    success("-2",message ?? "Do not have any story. Please upload",["1"],false)
//                } else if message == "You already have one active promotions.You must cancel this promotion before you can do another one." {
//                    success("-2",message ?? "You already have one active promotions.You must cancel this promotion before you can do another one.",["1"],false)
//                } else if message == "Your story has expired and it did not reach the required story views to claim the lowest discount. You must cancel this promotion before you can do another one." {
//                    success("-2",message ?? "Your story has expired and it did not reach the required story views to claim the lowest discount. You must cancel this promotion before you can do another one.",["1"],false)
//                }
            } catch(_) {
                success("-1", "0",[],false)
               //GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Failed to Get Story")
            }
        }
        task.resume()
    }
}
//               aryStoryCount = "1245"
//                aryStoryDiscount = "60"
//                aryInstaId = "2799511198497064445"
//                let reelsMedia = json["data"]?["reels_media"] as? [Dictionary<String, AnyObject>]
//                if !(reelsMedia?.isEmpty ?? true) {
////                    let items1 = reelsMedia?[0] as? NSDictionary
////                    print(items1!.object(forKey:"seen"))
////                    let items = reelsMedia?[0]["items"] as? [Dictionary<String, AnyObject>]
////                    print(items?[0]["seen"] as? String ?? "")
////                    if AppData.shared.user?.instagram == "" {
////                        let owner = items?[0]["owner"] as? Dictionary<String, AnyObject>
////                        AppData.shared.user?.instagram = owner?["username"] as? String ?? ""
////                        DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
////                        DatabaseManager.shared.getUser(completion: { success in })
////                    }
//                    if aryStoryCount != "0" {
//                       // success(totalSum,aryStoryIdCout.last ?? "")
//                        success(aryStoryCount,aryStoryDiscount,aryInstaId)
//                    } else {
//                        success("0", "0",aryInstaId)
//                    }
//                } else {
//                    success("-1", "0","0")
//                }
