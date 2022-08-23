//
//  AccountManagementViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 02/08/2022.
//

import Foundation
import UIKit
import Firebase

class AccountManagementViewController: UIViewController {
    let db = DatabaseManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if K.cookieString?.isEmpty ?? true || K.cookieString == "" {
            let vc = WebViewViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        } else {
            checkAccountStatus()
            
            let currentUser = Auth.auth().currentUser;
            if (currentUser == nil) {
                signout()
            }
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(obj, animated:true)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if K.cookieString?.isEmpty ?? true || K.cookieString == "" {
            let vc = WebViewViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        } else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(obj, animated:true)
        }
    }
    
    ///Checks account status and decides wether the user account needs to be deleted or forcefully signed out
    func checkAccountStatus(){
        var emailMain = String()
        if let emailGet = UserDefaults.standard.object(forKey:K.udefalt.EmailCurrent) {
            if "\(emailGet)" == "" {
                emailMain = ""
            } else {
                emailMain = "\(emailGet)"
            }
        }
        
        let docRef = DatabaseManager.shared.db.collection("Students").document(emailMain)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("accountStatus") != nil {
                    if document.get("accountStatus") as! Int == 1 {
                        docRef.setData(["accountStatus" : 0], merge: true)
                        
                        let alert = UIAlertController(title: "Account management", message: "There has been an error with your account. You will be signed out, please try to sign in again.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.signout()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    if document.get("accountStatus") as! Int == 2 {
                        docRef.setData(["accountStatus" : 0], merge: true)
                        
                        let alert = UIAlertController(title: "Account management", message: "There has been an undefined error with your account. Your account will be deleted, please try to register again.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.deleteUser()
                            docRef.delete()
                            self.signout()
                        }))
                        self.present(alert, animated: true, completion: nil)
                         
                        
                    }
                }
            }
        }
    }
    
    func deleteUser() {
            let user = Auth.auth().currentUser
            ActiveUser.activeUser.deleteData()

            user?.delete { error in
                if let error = error {
                print("Error occurred in deleting account: \(error)")
              } else {
                print("Account deleted")
                
                guard let navVC = self.presentingViewController?.presentingViewController?.presentingViewController as? UINavigationController else { return }
                
                navVC.dismiss(animated: true, completion: nil)
                            
                let firstVC = navVC.viewControllers.first
                if firstVC is SignUpViewController {
                    navVC.popToRootViewController(animated: true)

                } else {
                    firstVC?.performSegue(withIdentifier: K.Segues.signOut, sender: self)
                }
              }
            }
        }
    
    func signout() {
        do {
        try Auth.auth().signOut()
        print("User signed out")
        UserDefaults.standard.set(false, forKey:K.udefalt.isLogin)
        UserDefaults.standard.set(false, forKey:K.udefalt.IsRegister)
        UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
        UserDefaults.standard.removeObject(forKey:K.udefalt.EmailCurrent)
        UserDefaults.standard.removeObject(forKey:K.udefalt.Business)
        UserDefaults.standard.removeObject(forKey:K.udefalt.UserIdMain)
        UserDefaults.standard.set(false, forKey:"isTimeStart")
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        K.storyCount = 0
        K.userID = ""
        K.cookieString = ""
        AppData.shared.user = nil
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
    } catch let signOutError as NSError {
        print("Error signing out: \(signOutError)")
    }
    }
}

extension AccountManagementViewController: WebViewCotrollerDelegate {
    func hideView() {
        DispatchQueue.main.async {
            let vc = WebViewViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        }
    }
}
