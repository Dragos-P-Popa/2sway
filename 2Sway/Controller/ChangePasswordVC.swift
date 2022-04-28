//
//  ChangePasswordVC.swift
//  2Sway
//
//  Created by Techcronus on 18/04/22.
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {

    //MARK: IBoutlets
    @IBOutlet weak var tfCurentPasword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    
    //MARK: deClaration
    var emailMain = String()
    
    //MARK: ViewController_LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getemail()
        self.configureTextField()
    }
    
    //MARK: CustomFunction
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        print(email,currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
              //  GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error.localizedDescription)
                GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"The password is invalid or the user does not exist.")
            }
            else {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    self.UserSignOut()
                })
            }
        })
    }
    func getemail()  {
        if let emailGet = UserDefaults.standard.object(forKey:K.udefalt.EmailCurrent) {
            if "\(emailGet)" == "" {
                emailMain = ""
            } else {
                emailMain = "\(emailGet)"
            }
        }
    }
    func checkValidation() {
        if self.tfCurentPasword.text == "" {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"Please enter your old password")
        } else if self.tfNewPassword.text == "" {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"Please enter your new password")
        } else if self.tfNewPassword.text?.count ?? 0 < 6 {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"6 character minimum.")
        } else if self.tfConfirmPassword.text == "" {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"Please enter your confirm password")
        } else if self.tfNewPassword.text != self.tfConfirmPassword.text {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"password and confirm password not matching")
        } else if self.emailMain == "" {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:K.someWrong)
        } else {
            self.changePassword(email:emailMain,currentPassword:tfCurentPasword.text ?? "", newPassword:tfNewPassword.text ?? "") { error in
                print(error?.localizedDescription ?? "")
            }
        }
    }
    func UserSignOut() {
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
    func configureTextField() {
        
        tfCurentPasword.delegate = self
        tfNewPassword.delegate = self
        tfConfirmPassword.delegate = self
        
        tfCurentPasword.layer.cornerRadius = 27
        tfCurentPasword.layer.borderWidth = 1
        tfCurentPasword.layer.borderColor = UIColor(named: K.Colors.lightGrey)?.cgColor
        tfCurentPasword.backgroundColor = .clear
        tfCurentPasword.setLeftPaddingPoints(20)
        tfCurentPasword.setRightPaddingPoints(20)
        tfNewPassword.layer.cornerRadius = 27
        tfNewPassword.layer.borderWidth = 1
        tfNewPassword.layer.borderColor = UIColor(named: K.Colors.lightGrey)?.cgColor
        tfNewPassword.backgroundColor = .clear
        tfNewPassword.setLeftPaddingPoints(20)
        tfNewPassword.setRightPaddingPoints(20)
        tfConfirmPassword.layer.cornerRadius = 27
        tfConfirmPassword.layer.borderWidth = 1
        tfConfirmPassword.layer.borderColor = UIColor(named: K.Colors.lightGrey)?.cgColor
        tfConfirmPassword.backgroundColor = .clear
        tfConfirmPassword.setLeftPaddingPoints(20)
        tfConfirmPassword.setRightPaddingPoints(20)
        
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        
        tfCurentPasword.attributedPlaceholder = NSAttributedString(string: "Current Password",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
        tfNewPassword.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
        tfConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
    }
    
    //MARK: IBAction
    @IBAction func btnActionBack(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
    }
    @IBAction func btnActionSubmit(_ sender: Any) {
        self.checkValidation()
    }
}
//MARK: Extension_TextField
extension ChangePasswordVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfCurentPasword {
            self.tfNewPassword.becomeFirstResponder()
        } else if textField == tfNewPassword {
            self.tfConfirmPassword.becomeFirstResponder()
        } else {
            self.tfConfirmPassword.resignFirstResponder()
            self.view.endEditing(true)
        }
       return true
    }
}
