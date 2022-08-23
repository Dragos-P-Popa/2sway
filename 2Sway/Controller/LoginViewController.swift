//
//  LoginControllerViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 23/07/2021.
//

import UIKit
import Firebase
import MBProgressHUD
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var accountStatus = 0
    var strProfileUrl = ""
    var strname = ""
    var isExpire = ""
    var strEmail = ""
    var strInsta = ""
    var IntTotleng = 0
    var tier = 0
    var aryStoryIds = [String]()
    var aryStoryIds1 = [String]()
    var aryPromoMain = [StudentPromos]()
    var aryDataMonth = [DataThisMonth]()
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureTapGesture()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                AnalyticsParameterScreenName: "login"
            ])
        
        logInButton.layer.cornerRadius = 27
        
        let showPassword = UIButton(type: .custom)
        showPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        showPassword.tintColor = UIColor(named: K.Colors.lightGrey)
        showPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        showPassword.frame = CGRect(x: CGFloat(1000), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        btnLogin.setAttributedTitle(NSAttributedString(string: "Forgot Password?", attributes: [.underlineStyle: 1]), for: .normal)

        passwordField.rightView = showPassword
        showPassword.addTarget(self, action: #selector(showPasswordPressed), for: .touchDown)
        showPassword.addTarget(self, action: #selector(showPasswordUnpressed), for: .touchUpOutside)
        showPassword.addTarget(self, action: #selector(showPasswordUnpressed), for: .touchUpInside)
      //  self.emailField.text = "rm2017@cam.ac.uk"
      //  self.passwordField.text = "123456"
    }
    
    
    // When tap outside of text boxes, unshow keyboard
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
        
    }
    
    private func configureTextField() {
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.layer.cornerRadius = 27
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor(named: K.Colors.lightGrey)?.cgColor
        emailField.backgroundColor = .clear
        emailField.setLeftPaddingPoints(20)
        emailField.setRightPaddingPoints(20)
        passwordField.layer.cornerRadius = 27
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor(named: K.Colors.lightGrey)?.cgColor
        passwordField.backgroundColor = .clear
        passwordField.setLeftPaddingPoints(20)
        passwordField.setRightPaddingPoints(20)
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        
        emailField.attributedPlaceholder = NSAttributedString(string: "University Email",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
    }
    @IBAction func btnActionReset(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier:"ResetPassword") as! ResetPassword
        self.navigationController?.pushViewController(obj, animated:true)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        view.endEditing(true)
        
        if emailCheck(), passwordCheck() {
            saveLoginInfo()
        }
    }
    
    func saveLoginInfo() {
//        let email = emailField.text, let password = passwordField.text
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//          if let error = error as? NSError {
//            switch AuthErrorCode(rawValue: error.code) {
//            case .operationNotAllowed:
//                break
//              // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
//            case .userDisabled:
//                break
//              // Error: The user account has been disabled by an administrator.
//            case .wrongPassword:
//                break
//              // Error: The password is invalid or the user does not have a password.
//            case .invalidEmail:
//                break
//              // Error: Indicates the email address is malformed.
//            default:
//                print("Error: \(error.localizedDescription)")
//            }
//          } else {
//            print("User signs in successfully")
//            let userInfo = Auth.auth().currentUser
//            let email = userInfo?.email
//          }
        
        if let email = emailField.text, let password = passwordField.text {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    if let errorCode = AuthErrorCode(rawValue: e._code) {
                        switch errorCode {
                        case .invalidEmail:
                            self.emailField.flash2(numberOfFlashes: 3)
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                        case .emailAlreadyInUse:
                            self.emailField.flash2(numberOfFlashes: 3)
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                        case .wrongPassword:
                            self.passwordField.flash2(numberOfFlashes: 3)
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"The password is invalid or the user does not exist.")
                        default:
                            print("UNHANDLED ERROR HAS OCCURED")
                            print("An error with email or password occured: \(e)")
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? K.someWrong)
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                } else {
                    Analytics.logEvent(AnalyticsEventSelectContent, parameters: nil)
                    print(self.emailField.text?.localizedLowercase)
                    self.getDocument()
                    DatabaseManager.shared.getUser { test in
                        print()
                    }
                }
            }
        }
    }
    func getDocument() {
        //Get specific document from current user
        //let docRef = Firestore.firestore()
        //  .collection("Students").document("rm2017@cam.ac.uk").collection("name").document("rm2017@cam.ac.uk")
        let docRef = Firestore.firestore()
            .collection("Students").whereField("email", isEqualTo:self.emailField.text ?? "".localizedLowercase)
        
        // Get data
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }  else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                if let dictMain = dataDescription as? NSDictionary {
                    if let proPic = dictMain.object(forKey:"urlString") {
                        self.strProfileUrl = "\(proPic)"
                    }
                    if let isExpire = dictMain.object(forKey:"isExpire") {
                        self.isExpire = "\(isExpire)"
                    } else {
                        self.isExpire = ""
                    }
                    if let status = dictMain.object(forKey: "accountStatus") as? Int {
                        self.accountStatus = status
                    }
                    if let email = dictMain.object(forKey:"email") {
                        self.strEmail = "\(email)"
                    }
                    if let name = dictMain.object(forKey:"name") {
                        self.strname = "\(name)"
                    }
                    if let instagram = dictMain.object(forKey:"instagram") {
                        self.strInsta = "\(instagram)"
                    }
                    if let currentTier = dictMain.object(forKey: "tier") as? Int {
                        self.tier = currentTier
                    }
                    if let totalEngagements = dictMain.object(forKey:"totalEngagements") as? Int {
                        self.IntTotleng = totalEngagements
                    }
//                    if let storyID = dictMain.object(forKey:"storyID") as? NSMutableArray {
//                       print(storyID)
//                    }
                    let storyID = dictMain.object(forKey:"storyID")
                    print(storyID)
                    if let storyIds = dictMain.object(forKey:"storyIds") as? [String] {
                        for i in storyIds {
                            self.aryStoryIds.append(i)
                        }
                    }
                    UserDefaults.standard.set(self.strEmail, forKey:K.udefalt.EmailCurrent)
                    if let promos = dictMain.object(forKey:"promos") as? NSArray {
                        for i in 0..<promos.count {
                            if let mainPromos = promos.object(at:i) as? NSDictionary {
                                        if let storyIds = mainPromos.object(forKey:"storyID") as? [String] {
                                            for i in storyIds {
                                                self.aryStoryIds1.append(i)
                                            }
                                        }
                                if let storyIds = mainPromos.object(forKey:"storyID") as? String {
                                        self.aryStoryIds1.append(storyIds)
                                }
                                print(self.aryStoryIds1)
                                let claimedPromo = StudentPromos(businessID:mainPromos.object(forKey:"businessID") as! String, promoName:mainPromos.object(forKey:"businessID") as! String, discount:mainPromos.object(forKey:"discount") as? Int ?? 0, isClaimed:mainPromos.object(forKey:"isClaimed") as? Bool ?? false , storyID:self.aryStoryIds1, storyCount:mainPromos.object(forKey:"storyCount") as? Int ?? 0, totalEngagements:mainPromos.object(forKey:"totalEngagements") as? Int ?? 0)
                                self.aryPromoMain.append(claimedPromo)
                            }
                        }
                    }
                    /*if self.strProfileUrl == "" {
                        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "isPhoto") as? TakePhotoViewController else {
                            return
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let navigationController = UINavigationController(rootViewController: rootVC)
                        navigationController.navigationBar.isHidden = true
                        UserDefaults.standard.set(false, forKey:K.udefalt.IsPhoto)
                        UserDefaults.standard.set(true, forKey:K.udefalt.IsRegister)
                        UIApplication.shared.windows.first?.rootViewController = navigationController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    } else { */
                        UserDefaults.standard.set(true, forKey:K.udefalt.isLogin)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountManagementViewController") as! AccountManagementViewController
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    
                    //}
                    AppData.shared.user = UserModel(accountStatus:self.accountStatus, email:self.strEmail, name:self.strname, isExpire:self.isExpire, urlString:self.strProfileUrl, dataThisMonth:DataThisMonth(), tier: self.tier, totalEngagements:self.IntTotleng, promos:self.aryPromoMain, instagram:self.strInsta, storyIds:self.aryStoryIds)
                    DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                    DatabaseManager.shared.getUser(completion: { success in
    //                    if let test = UserDefaults.standard.object(forKey:K.udefalt.ProPic) {
    //                        print("\(test)")
    //                    }
                        
                    })
                }
            }
        }
    }

  
    func emailCheck() -> Bool {
        if emailField.text == "" {
            emailField.flash2(numberOfFlashes: 3)
           // GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please enter email")
            return false
        } else {
            return true
        }
    }
    
    func passwordCheck() -> Bool {
        if passwordField.text == "" {
            passwordField.flash2(numberOfFlashes: 3)
           // GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please enter password")
            return false
        }else if  passwordField.text!.count < 6 {
            passwordField.text = ""
            passwordField.placeholder = "6 character minimum."
            passwordField.flash2(numberOfFlashes: 3)
          //  GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please Enter Atleast 6 characer")
            return false
        }  else {
            return true
        }
    }
    
    @objc private func showPasswordPressed() {
        passwordField.isSecureTextEntry = false
    }
    @objc private func showPasswordUnpressed() {
        passwordField.isSecureTextEntry = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        //navigationController?.popViewController(animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
//        if passwordField.isFirstResponder {
//            textField.resignFirstResponder()
//
//            if emailCheck(), passwordCheck() {
//                saveLoginInfo()
//            }
//        } else {
//            passwordField.becomeFirstResponder()
//        }
        return true
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
//if let isCheckPhoto = UserDefaults.standard.object(forKey:K.udefalt.IsPhoto) as? Bool {
//    if isCheckPhoto  {
//        UserDefaults.standard.set(true, forKey:K.udefalt.isLogin)
//        MBProgressHUD.hide(for: self.view, animated: true)
//        self.performSegue(withIdentifier: K.Segues.logInToHome, sender: self)
//    } else {
//        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "isPhoto") as? TakePhotoViewController else {
//            return
//        }
//        MBProgressHUD.hide(for: self.view, animated: true)
//        let navigationController = UINavigationController(rootViewController: rootVC)
//        navigationController.navigationBar.isHidden = true
//        UIApplication.shared.windows.first?.rootViewController = navigationController
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//    }
//} else {
//
//    guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "isPhoto") as? TakePhotoViewController else {
//        return
//    }
//    MBProgressHUD.hide(for: self.view, animated: true)
//    let navigationController = UINavigationController(rootViewController: rootVC)
//    navigationController.navigationBar.isHidden = true
//    UIApplication.shared.windows.first?.rootViewController = navigationController
//    UIApplication.shared.windows.first?.makeKeyAndVisible()
//}


//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    self.performSegue(withIdentifier: K.Segues.logInToHome, sender: self)
//                    if let ProfilePic = AppData.shared.user?.urlString as? String {
//                        if ProfilePic != "" {
//                            UserDefaults.standard.set(true, forKey:K.udefalt.isLogin)
//                            MBProgressHUD.hide(for: self.view, animated: true)
//                         //   AppData.shared.user = UserModel(email: email, name: name, urlString: "", dataThisMonth: DataThisMonth(), totalEngagements: 0, promos: [], instagram: "", storyIds: [])
//                            self.performSegue(withIdentifier: K.Segues.logInToHome, sender: self)
//                        } else {
//                            guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "isPhoto") as? TakePhotoViewController else {
//                                return
//                            }
//                            MBProgressHUD.hide(for: self.view, animated: true)
//                            let navigationController = UINavigationController(rootViewController: rootVC)
//                            navigationController.navigationBar.isHidden = true
//                            UIApplication.shared.windows.first?.rootViewController = navigationController
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                        }
//                    }else {
//                        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "isPhoto") as? TakePhotoViewController else {
//                            return
//                        }
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                        let navigationController = UINavigationController(rootViewController: rootVC)
//                        navigationController.navigationBar.isHidden = true
//                        UIApplication.shared.windows.first?.rootViewController = navigationController
//                        UIApplication.shared.windows.first?.makeKeyAndVisible()
//                    }
