//
//  SceneDelegate.swift
//  progressBar2
//
//  Created by Joe Feest on 22/07/2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let db = Firestore.firestore()
    var appVersionCurent = String()
    var appOldVersion = String()

 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        appVersionCurent = appVersion!.replacingOccurrences(of: ".", with: "")
        if let windowScene = scene as? UIWindowScene {
            
//            ActiveUser.activeUser.signOut()
            
            let window = UIWindow(windowScene: windowScene)

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            let DiscountCodeController = storyboard.instantiateViewController(withIdentifier: "DiscountCodeController") as! DiscountCodeController
            let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            let isPhoto = storyboard.instantiateViewController(withIdentifier:"isPhoto") as! TakePhotoViewController
            let Login = storyboard.instantiateViewController(withIdentifier:"Login") as! LoginViewController
            //let Test = storyboard.instantiateViewController(withIdentifier:"test") as! UIViewController
//            let navigationController = UINavigationController.init(rootViewController: Test)
//                                   navigationController.setNavigationBarHidden(true, animated: false)
//                                  window.rootViewController = navigationController
//
            if let isCheckPhoto = UserDefaults.standard.object(forKey:K.udefalt.IsPhoto) as? Bool {
                if isCheckPhoto  {
                    var isExistingUser: Bool
                    if Auth.auth().currentUser != nil {
                        isExistingUser = true
                    } else {
                        isExistingUser = false
                    }
                    if isExistingUser {
                        let navigationController = UINavigationController.init(rootViewController: homeVC)
                        navigationController.setNavigationBarHidden(true, animated: false)
                        window.rootViewController = navigationController
                        DatabaseManager.shared.updateLocalDetails()
                    } else {
                        let navigationController = UINavigationController.init(rootViewController: signupVC)
                        navigationController.setNavigationBarHidden(true, animated: false)
                        window.rootViewController = navigationController
                    }
                } else {
                    let navigationController = UINavigationController.init(rootViewController: isPhoto)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    window.rootViewController = navigationController
                }
            }  else {
                let navigationController = UINavigationController.init(rootViewController: isPhoto)
                navigationController.setNavigationBarHidden(true, animated: false)
                window.rootViewController = navigationController
            }
            self.window = window
            window.makeKeyAndVisible()
            
            var isExistingUser: Bool
            if Auth.auth().currentUser != nil {
                isExistingUser = true
            } else {
                isExistingUser = false
            }
            
            if let checkLogin = UserDefaults.standard.object(forKey:K.udefalt.isLogin) as? Bool {
                if checkLogin == true {
                    //if let checkTimer = UserDefaults.standard.object(forKey:"isTimeStart") as? Bool {
//                        if checkTimer == true {
//                            let navigationController = UINavigationController.init(rootViewController: DiscountCodeController)
//                            navigationController.setNavigationBarHidden(true, animated: false)
//                            window.rootViewController = navigationController
//                            DatabaseManager.shared.updateLocalDetails()
//                        } else {
//                            let navigationController = UINavigationController.init(rootViewController: homeVC)
//                            navigationController.setNavigationBarHidden(true, animated: false)
//                            window.rootViewController = navigationController
//                            DatabaseManager.shared.updateLocalDetails()
//                        }
                        let navigationController = UINavigationController.init(rootViewController: homeVC)
                        navigationController.setNavigationBarHidden(true, animated: false)
                        window.rootViewController = navigationController
                        DatabaseManager.shared.updateLocalDetails()
                  //  }
                } else {
                    if let checkRegister = UserDefaults.standard.object(forKey:K.udefalt.IsRegister) as? Bool {
                        if checkRegister == true {
                            if let isCheckPhoto = UserDefaults.standard.object(forKey:K.udefalt.IsPhoto) as? Bool {
                                if isCheckPhoto  {
                                    let navigationController = UINavigationController.init(rootViewController: homeVC)
                                    navigationController.setNavigationBarHidden(true, animated: false)
                                    window.rootViewController = navigationController
                                    DatabaseManager.shared.updateLocalDetails()
                                } else {
                                    
                                    let navigationController = UINavigationController.init(rootViewController: Login)
                                    navigationController.setNavigationBarHidden(true, animated: false)
                                    window.rootViewController = navigationController
                                    DatabaseManager.shared.updateLocalDetails()
                                }
                            } else {
                                let navigationController = UINavigationController.init(rootViewController: homeVC)
                                navigationController.setNavigationBarHidden(true, animated: false)
                                window.rootViewController = navigationController
                                DatabaseManager.shared.updateLocalDetails()
                            }
                        } else {
                                let navigationController = UINavigationController.init(rootViewController: signupVC)
                                navigationController.setNavigationBarHidden(true, animated: false)
                                window.rootViewController = navigationController
                                DatabaseManager.shared.updateLocalDetails()
                        }
                    } else {
                        let navigationController = UINavigationController.init(rootViewController: signupVC)
                        navigationController.setNavigationBarHidden(true, animated: false)
                        window.rootViewController = navigationController
                        DatabaseManager.shared.updateLocalDetails()
                    }
                }
            } else {
                if let checkRegister = UserDefaults.standard.object(forKey:K.udefalt.IsRegister) as? Bool {
                    if checkRegister == true {
                        if let isCheckPhoto = UserDefaults.standard.object(forKey:K.udefalt.IsPhoto) as? Bool {
                            if isCheckPhoto  {
                                let navigationController = UINavigationController.init(rootViewController: homeVC)
                                navigationController.setNavigationBarHidden(true, animated: false)
                                window.rootViewController = navigationController
                                DatabaseManager.shared.updateLocalDetails()
                            } else {
                                let navigationController = UINavigationController.init(rootViewController: Login)
                                navigationController.setNavigationBarHidden(true, animated: false)
                                window.rootViewController = navigationController
                                DatabaseManager.shared.updateLocalDetails()
                            }
                        } else {
                            let navigationController = UINavigationController.init(rootViewController: Login)
                            navigationController.setNavigationBarHidden(true, animated: false)
                            window.rootViewController = navigationController
                            DatabaseManager.shared.updateLocalDetails()
                        }
                    } else {
                            let navigationController = UINavigationController.init(rootViewController: signupVC)
                            navigationController.setNavigationBarHidden(true, animated: false)
                            window.rootViewController = navigationController
                            DatabaseManager.shared.updateLocalDetails()
                    }
                } else {
                    let navigationController = UINavigationController.init(rootViewController: signupVC)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    window.rootViewController = navigationController
                    DatabaseManager.shared.updateLocalDetails()
                }
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    func checkForAppVersionUpdate(CurentVersion:String,LiveVersion:String) {
        if CurentVersion > LiveVersion {
            let alert=UIAlertController(title:"Serious update.", message: "Download it from the App Store now to continue using 2Sway", preferredStyle:UIAlertController.Style.alert )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    _ in
                if let url = URL(string: "https://apps.apple.com/us/app/2sway-share-get-rewarded/id1607213123"),
                    UIApplication.shared.canOpenURL(url)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
            UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
     //   Siren.shared.checkVersion(checkType: .daily)
        DatabaseManager.shared.db.collection("version").getDocuments() { [self] documents, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                do{
                    for document in documents!.documents {
                        print("Firebase data ", document.data())
                        let dataDescription = document.data()
                        let appVersion = dataDescription["min_version"] as! String
                        self.appOldVersion = appVersion.replacingOccurrences(of: ".", with: "")
                        print(self.appOldVersion)
                        self.checkForAppVersionUpdate(CurentVersion:appOldVersion, LiveVersion:appVersionCurent)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

