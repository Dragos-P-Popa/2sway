//
//  SettingsViewController.swift
//  progressBar2
//
//  Created by user201027 on 8/2/21.
//

import UIKit
import Firebase
import SDWebImage
import MBProgressHUD
import SwiftUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var DMUsText: UILabel!
    var textFieldAlert: UITextField?

    var shareableString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareableString = K.Share.shareString
        NameLabel.text = "\(AppData.shared.user?.name ?? "")"
        DMUsText.attributedText = NSAttributedString(string: "DM us @2SwayUK for help", attributes: [.underlineStyle: 1])
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification11(notification:)), name: Notification.Name("NotificationProgress1"), object: nil)
        
//        if AppData.shared.user?.urlString == "" {
//            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
//            loadingNotification.mode = MBProgressHUDMode.indeterminate
//            loadingNotification.label.text = "Profile Picture Updataing"
//        } else {
//            updateDisplayedPic()
//        }
        
    }

    @objc func methodOfReceivedNotification11(notification: Notification) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(goToRetake), name: Notification.Name("goToRetake"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("goToRetake"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateDisplayedPic"), object: nil)
    }
    
    
    func DeletePassword(email:String,pass:String) {
        Auth.auth().signIn(withEmail: email, password: pass) { authResult, error in
            if let e = error {
                if let errorCode = AuthErrorCode(rawValue: e._code) {
                    switch errorCode {
                    case .invalidEmail:
                        MBProgressHUD.hide(for:self.view, animated:true)
                        GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                    case .emailAlreadyInUse:
                        //self.emailField.flash2(numberOfFlashes: 3)
                        MBProgressHUD.hide(for:self.view, animated:true)
                        GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                    case .wrongPassword:
                        MBProgressHUD.hide(for:self.view, animated:true)
                        // self.passwordField.flash2(numberOfFlashes: 3)
                        GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                    default:
                        GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            } else {
                let user = Auth.auth().currentUser
                user?.delete { error in
                  if let error = error {
                      MBProgressHUD.hide(for:self.view, animated:true)
                      GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error.localizedDescription ?? K.someWrong)
                  } else {
                      MBProgressHUD.hide(for:self.view, animated:true)
                      UserDefaults.standard.set(false, forKey:K.udefalt.isLogin)
                      UserDefaults.standard.set(false, forKey:K.udefalt.IsRegister)
                      UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
                      UserDefaults.standard.removeObject(forKey:K.udefalt.EmailCurrent)
                    //  UserDefaults.standard.set(false, forKey:K.udefalt.IsPhoto)
                      let domain = Bundle.main.bundleIdentifier!
                      UserDefaults.standard.removePersistentDomain(forName: domain)
                      UserDefaults.standard.synchronize()
                      K.storyCount = 0
                      K.userID = ""
                    //  K.cookieString = ""
                      AppData.shared.user = nil
                      
                      HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                      guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
                          return
                      }
                      let navigationController = UINavigationController(rootViewController: rootVC)
                      navigationController.navigationBar.isHidden = true
                      UIApplication.shared.windows.first?.rootViewController = navigationController
                      UIApplication.shared.windows.first?.makeKeyAndVisible()
                  }
                }
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rulesButtonPressed(_ sender: UIButton) {
     //   let vc = SplashRulesViewController()
     //   let vc = self.storyboard?.instantiateViewController(withIdentifier:"RulesVC") as! RulesVC
     //   vc.backButton.setImage(UIImage(named: K.ImageNames.downArrowWhite), for: .normal)
     //   vc.modalPresentationStyle = .fullScreen
     //   present(vc, animated: true, completion: nil)
        
        let OnboardingView = UIHostingController(rootView: OnboardingViewController(dismissAction: {self.dismiss( animated: true, completion: nil )}))
        present( OnboardingView, animated: true )
        
    }
    
    @IBAction func giveFeedbackPressed(_ sender: Any) {
        let vc = FeedbackViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    @IBAction func btnActionChangePass(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier:"ChangePasswordVC") as! ChangePasswordVC
        obj.modalPresentationStyle = .overCurrentContext
        self.present(obj, animated:true, completion:nil)
    }
    
    
    @IBAction func inviteFriendsButtonPressed(_ sender: UIButton) {
        presentShareSheet()
    }

    private func presentShareSheet() {
        
        guard let shareable = shareableString else {
            return
        }
        let VC = UIActivityViewController(activityItems: [shareable], applicationActivities: nil)
        present(VC, animated: true)
    }

    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textFieldAlert = textField!
            self.textFieldAlert?.isSecureTextEntry = true
            self.textFieldAlert?.placeholder = " Please Enter your password ";
        }
    }

    func openAlertView() {
        var emailMain = String()
        let alert = UIAlertController(title: K.appName, message: "Enter your password to Delete your account!", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            if self.textFieldAlert?.text != "" {
                if let emailGet = UserDefaults.standard.object(forKey:K.udefalt.EmailCurrent) {
                    if "\(emailGet)" == "" {
                        emailMain = ""
                    } else {
                        emailMain = "\(emailGet)"
                    }
                }
                if emailMain == "" || self.textFieldAlert!.text! == "" {
                    MBProgressHUD.hide(for:self.view, animated:true)
                    GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:K.someWrong)
                } else {
                    Analytics.logEvent("deleteAccount", parameters: [
                        "Description": "User has deleted their account manually. Excludes forced removal." as NSObject
                    ])
                    MBProgressHUD.showAdded(to:self.view, animated:true)
                    self.DeletePassword(email:emailMain, pass:(self.textFieldAlert?.text!)!)
                }
            } else {
                MBProgressHUD.hide(for:self.view, animated:true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnDeleteAcoount(_ sender: Any) {
        self.openAlertView()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title:K.appName, message: "Are you sure want to log out?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
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
              //  UserDefaults.standard.set(false, forKey:K.udefalt.IsPhoto)
             //   guard let navVC = presentingViewController as? UINavigationController else { return }
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
    //            let firstVC = navVC.viewControllers.first
    //            if firstVC is SignUpViewController {
    //                navVC.popToRootViewController(animated: true)
    //                self.dismiss(animated: true, completion: nil)
    //
    //            } else {
    //                navVC.popToRootViewController(animated: true)
    //                self.dismiss(animated: true, completion: nil)
    //                firstVC?.performSegue(withIdentifier: K.Segues.signOut, sender: self)
    //            }
                            
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func igButtonClick(_ sender: Any)
    {
            let appURL = URL(string: "instagram://user?username=2swayuk")!
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL)
            {
                application.open(appURL)
            }
            else
            {
                let webURL = URL(string: "https://instagram.com/2swayuk")!
                application.open(webURL)
            }
    }
    
    @IBAction func termsButtonPressed(_ sender: UIButton) {
        GlobalShare.ShareUrl(urlPath:"https://www.2sway.co.uk/termsconditions")
        //performSegue(withIdentifier: K.Segues.toTerms, sender: self)
    }
    
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
        GlobalShare.ShareUrl(urlPath:"https://www.2sway.co.uk/privacypolicy")
       //performSegue(withIdentifier: K.Segues.toPrivacy, sender: self)
    }
    
    
    @objc func goToRetake() {
        performSegue(withIdentifier: K.Segues.toRetakeCam, sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PrivacyViewController {
            vc.unhideDelete()
        }
    }
}
