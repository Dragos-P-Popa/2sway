//
//  AppDelegate.swift
//  progressBar2
//
//  Created by Joe Feest on 22/07/2021.
//

import UIKit
import Firebase
import OneSignal
import FacebookCore

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
        
 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("517494aa-9bec-45c8-b171-89e481572528")

        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
        print("User accepted notifications: \(accepted)")
        })

        // Set your customer userId
        // OneSignal.setExternalUserId("userId")
        
        let notificationOpenedBlock: OSNotificationOpenedBlock = { result in
            // This block gets called when the user reacts to a notification received
            let notification: OSNotification = result.notification
            print("Message: ", notification.body ?? "empty body")
            print("badge number: ", notification.badge)
            print("notification sound: ", notification.sound ?? "No sound")
                    
            if let additionalData = notification.additionalData {
                print("additionalData: ", additionalData)
                let givePromo = additionalData["givePromo"] ?? ""
                let promoLevel = additionalData["promoLevel"] ?? 0
                //let email = Auth.auth().currentUser?.email ?? ""
                
                let claimedPromo = StudentPromos(businessID: givePromo as! String, promoName: "Your reward", discount: 40, isClaimed: true, storyID: ["00000"], storyCount: 0, totalEngagements: 0)
                AppData.shared.user?.promos.append(claimedPromo)
                DatabaseManager.shared.uploadLocalClaimedPromos()
                
                if let actionSelected = notification.actionButtons {
                    print("actionSelected: ", actionSelected)
                }
                if let actionID = result.action.actionId {
                    //handle the action
                }
            }
        }

        OneSignal.setNotificationOpenedHandler(notificationOpenedBlock)
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        print(db)
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
        
        // Setting External User Id with Callback Available in SDK Version 3.0.0+
        OneSignal.setExternalUserId((Auth.auth().currentUser?.email) ?? "undefined", withSuccess: { results in
            // The results will contain push and email success statuses
            print("External user id update complete with results: ", results!.description)
            // Push can be expected in almost every situation with a success status, but
            // as a pre-caution its good to verify it exists
            if let pushResults = results!["push"] {
                print("Set external user id push status: ", pushResults)
            }
            if let emailResults = results!["email"] {
                print("Set external user id email status: ", emailResults)
            }
            if let smsResults = results!["sms"] {
                print("Set external user id sms status: ", smsResults)
            }
        }, withFailure: {error in
            print("Set external user id done with error: " + error.debugDescription)
        })
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jost", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Jost", size: 10)!], for: .selected)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

