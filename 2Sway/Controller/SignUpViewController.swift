//
//  SignUpController.swift
//  progressBar2
//
//  Created by user200155 on 8/19/21.
//

import UIKit
import Firebase
import MBProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    
    var isPassword = Bool()
    var isTerms = Bool()

    @IBAction func termsPressed(_ sender: UIButton) {
        GlobalShare.ShareUrl(urlPath:"https://www.2sway.co.uk/termsconditions")
       // present(TermsViewController(), animated: true, completion: nil)
    }
    
    @IBAction func privacyPressed(_ sender: UIButton) {
        GlobalShare.ShareUrl(urlPath:"https://www.2sway.co.uk/privacypolicy")

       // present(PrivacyViewController(), animated: true, completion: nil)
    }
            
    override func viewDidLoad() {

        super.viewDidLoad()
        configureTextField()
        configureTapGesture()
        signUpButton.layer.cornerRadius = 27
        logInButton.setAttributedTitle(NSAttributedString(string: "Already have an account? Log in", attributes: [.underlineStyle: 1]), for: .normal)
        
        let showPassword = UIButton(type: .custom)
        showPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        showPassword.tintColor = UIColor(named: K.Colors.lightGrey)
        showPassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        showPassword.frame = CGRect(x: CGFloat(1000), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        
        passwordField.rightView = showPassword
//        showPassword.addTarget(self, action: #selector(showPasswordPressed), for: .touchDown)
//        showPassword.addTarget(self, action: #selector(showPasswordUnpressed), for: .touchUpOutside)
        showPassword.addTarget(self, action: #selector(showPasswordUnpressed), for: .touchUpInside)
        
        termsButton.setAttributedTitle(NSAttributedString(string: "Terms of Use", attributes: [.underlineStyle: 1]), for: .normal)
        privacyButton.setAttributedTitle(NSAttributedString(string: "Privacy Policy", attributes: [.underlineStyle: 1]), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.passwordField.text = ""
        self.emailField.text = ""
        self.nameField.text = ""
        self.isTerms = false
        self.btnTerms.setImage(UIImage(named:"uncheckbox"), for:.normal)
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap() {
        view.endEditing(true)
    }


    private func configureTextField() {

        emailField.delegate = self
        passwordField.delegate = self
        nameField.delegate = self

        nameField.layer.cornerRadius = 27
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor =  UIColor(named: K.Colors.lightGrey)?.cgColor
        nameField.backgroundColor = .clear
        nameField.setLeftPaddingPoints(20)
        nameField.setRightPaddingPoints(20)

        emailField.layer.cornerRadius = 27
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor =  UIColor(named: K.Colors.lightGrey)?.cgColor
        emailField.backgroundColor = .clear
        emailField.setLeftPaddingPoints(20)
        emailField.setRightPaddingPoints(20)
       
        passwordField.layer.cornerRadius = 27
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor =  UIColor(named: K.Colors.lightGrey)?.cgColor
        passwordField.backgroundColor = .clear
        passwordField.setLeftPaddingPoints(20)
        passwordField.setRightPaddingPoints(20)

        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        emailField.attributedPlaceholder = NSAttributedString(string: "University Email",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Create Password",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
        nameField.attributedPlaceholder = NSAttributedString(string: "What should we call you?",
                                                                  attributes: [.foregroundColor: UIColor.lightGray,
                                                                               .font: UIFont(name: K.font, size: 14)!,
                                                                               .paragraphStyle: centeredParagraphStyle])
    }

    @IBAction func signUpButton(_ sender: UIButton) {
        view.endEditing(true)
        if isTerms == false {
            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please agree to the Terms and Conditions")
        } else if nameCheck(), passwordCheck() , emailCheck() { //, emailCheck() { ,  emailCheck() 
            Analytics.logEvent("signup", parameters: [
                "description": "New user has signed up." as NSObject
            ])
            saveSignUpInfo()
        }
    }


    func saveSignUpInfo() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let email = emailField.text, let password = passwordField.text, let name = nameField.text {
            Auth.auth().createUser(withEmail: email.localizedLowercase, password: password) { authResult, error in
                if let e = error {
                    if let errorCode = AuthErrorCode(rawValue: e._code) {
                        switch errorCode {
                        case .emailAlreadyInUse:
                            self.emailField.flash2(numberOfFlashes: 3)
                            self.emailField.text = ""
                            self.emailField.placeholder = "Email already in use"
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Email already in use")
                        default:
                            print("UNHANDLED ERROR OCCURED: \(e.localizedDescription)")
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:e.localizedDescription)
                        }
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                } else {
                    guard let currentUser = Auth.auth().currentUser else {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Can't get current user, please try again later")
                        fatalError("Can't get current user")
                        //GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Can't get current user  , please try aftersometime")
                    }
                    if currentUser.isEmailVerified == false {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        UserDefaults.standard.set(email, forKey:K.udefalt.EmailCurrent)
                        self.sendVerification()
                        print(DataThisMonth())
                        AppData.shared.user = UserModel(accountStatus: 0, email: email, name: name , isExpire:"", urlString: "", dataThisMonth: DataThisMonth(), totalEngagements: 0, promos: [], instagram: "", storyIds: [])
                        DatabaseManager.shared.uploadUser(user:UserModel(accountStatus: 0, email: email, name: name ,isExpire:"", urlString: "", dataThisMonth: DataThisMonth(), totalEngagements: 0, promos: [], instagram: "", storyIds: []))
                        UserDefaults.standard.set(true, forKey:K.udefalt.IsRegister)
                        self.performSegue(withIdentifier: K.Segues.toTakePhoto, sender: self)
//                        let vc = WebViewViewController()
//                        vc.delegate = self
//                        vc.modalPresentationStyle = .formSheet
//                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func sendVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error == nil {
                print("Verification email sent")
            } else {
                print("Verification email error")
                print(error?.localizedDescription)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func emailCheck() -> Bool {
        
        if emailField.text == "" {
            print("Enter an email")
            emailField.flash2(numberOfFlashes: 3)
            return false
        }
        
        let strToCheck = "@"
        let strToCheck2 = ".ac.uk"
        
        if (emailField.text!.contains(strToCheck)) {
            if emailField.text!.contains(strToCheck2) {
                return true
            } else {
                emailField.flash2(numberOfFlashes: 3)
                emailField.text = ""
                emailField.placeholder = "Must be a student email"
                return false
            }
        } else {
            emailField.text = ""
            emailField.placeholder = "Invalid Email"
            emailField.flash2(numberOfFlashes: 3)
           //GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please Enter Valid Email")
            return false
        }
    }
    
    func passwordCheck() -> Bool {
//        if passwordField.text == "" {
//          //  GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please Enter Password")
//            return false
//        } else {
//            return true
//        }
        
         if  passwordField.text!.count < 6 {
           passwordField.text = ""
           passwordField.placeholder = "6 character minimum"
           passwordField.flash2(numberOfFlashes: 3)
         //  GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please Enter Atleast 6 characer")
           return false
         }  else {
             return true
         }
    }
    
    func nameCheck() -> Bool {
        if nameField.text == "" {
            print("Enter a name")
            nameField.flash2(numberOfFlashes: 3)
        //    GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Please Enter Name")
            return false
        } else {
            return true
        }
    }
    
    @objc private func showPasswordPressed() {
    }
    
    @objc private func showPasswordUnpressed() {
        if isPassword {
            passwordField.isSecureTextEntry = true
            isPassword = false
        } else {
            passwordField.isSecureTextEntry = false
            isPassword = true
        }
      //  passwordField.isSecureTextEntry = true
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.toLogin, sender: self)
    }
    @IBAction func btnActionTerms(_ sender: Any) {
        if isTerms == false {
            self.btnTerms.setImage(UIImage(named:"checkbox"), for:.normal)
            self.isTerms = true
        } else {
            self.btnTerms.setImage(UIImage(named:"uncheckbox"), for:.normal)
            self.isTerms = false
        }
    }
    
}

extension SignUpViewController: WebViewCotrollerDelegate {
    func hideView() {
        self.performSegue(withIdentifier: K.Segues.toTakePhoto, sender: self)
    }
}

extension UITextField {
        func flash2(numberOfFlashes: Float) {
           let flash = CABasicAnimation(keyPath: "opacity")
           flash.duration = 0.1
           flash.fromValue = 1
           flash.toValue = 0.1
           flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
           flash.autoreverses = true
           flash.repeatCount = numberOfFlashes
           layer.add(flash, forKey: nil)
       }
 }
