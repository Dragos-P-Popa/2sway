//
//  StroyCountAPICall.swift
//  2Sway
//
//  Created by Abhishek Dubey on 06/01/22.
//

import Foundation


class APIClient {
    
    
    /**
    Function for fetching a user's story count.

    - parameter urlMain: URL string for 2Sway server.
    - parameter parametersInsta:Instageam UserID and cookie information.
    - returns: Returns story count in the form of an Int
    - warning: May fail if user has not posted on their story or they have not added the location tag

     # Notes: #
     1. Needs to be re-written as it is messy.
    */
    func getStoryCount1(urlMain:String,parametersInsta:[String:Any],success: @escaping(String, String ,[String],Bool) -> Void, fail: @escaping(Error?) -> Void) {
        // let urlString = "http://77.68.72.78/story/getStories.php"
        var request = URLRequest(url: URL(string:urlMain)!,timeoutInterval: 60)
        request.httpMethod = "POST"
        request.httpBody = parametersInsta.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            
            // print("API call data ", String(data: data, encoding: .utf8)!)
            do {
                print(data)
                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                let message = json["msg"] as? String
                if message == "success" {
                    var aryCheck = NSArray()
                    let count = json["data"] as? NSDictionary
                    if let reelsAry = count?.object(forKey:"reels_media") as? NSArray {
                        aryCheck = reelsAry
                    }
                    var aryStoryCount = String()
                    var aryStoryDiscount = String()
                    var aryInstaId = [String]()
                    aryStoryCount = "\(count?.object(forKey:"count") ?? "")"
                    aryStoryDiscount = "\(count?.object(forKey:"discount") ?? "")"
                    aryInstaId = count?.object(forKey:"storyID") as! [String]
                    //aryStoryCount = "1245"
                    // aryStoryDiscount = "60"
                    if aryCheck.count == 0 {
                        success(aryStoryCount,aryStoryDiscount,aryInstaId,true)
                        print(success)
                    } else {
                        if aryStoryCount != "0" {
                           // success(totalSum,aryStoryIdCout.last ?? "")
                            success(aryStoryCount,aryStoryDiscount,aryInstaId,false)
                            print(success)
                        } else {
                            success("0", "0",aryInstaId,false)
                            print(success)
                        }
                    }
                } else {
                    print(message)
                    success("-2",message ?? "",["1"],false)
                }
            } catch let error {
                print(error)
                success("-1", "0",[],false)
            }
        }
        task.resume()
    }
    
}
