//
//  ResetPassword.swift
//  2Sway
//
//  Created by Techcronus on 18/04/22.
//

import UIKit
import Firebase

class ResetPassword: UIViewController {
    
    //MARK: IBoutlets
    @IBOutlet weak var tfEmail: UITextField!
    
    // MARK: - ViewController_Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.configureTextField()
    }
    
    //MARK: CustomFunction
    func ResetPassword() {
        Auth.auth().sendPasswordReset(withEmail:tfEmail.text ?? "") { error in
            DispatchQueue.main.async {
                if error != nil {
                    GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? "")
                } else {
                    
                    let refreshAlert = UIAlertController(title:K.appName, message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
                            return
                        }
                        let navigationController = UINavigationController(rootViewController: rootVC)
                        navigationController.navigationBar.isHidden = true
                        UIApplication.shared.windows.first?.rootViewController = navigationController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                      }))
                    self.present(refreshAlert, animated: true, completion: nil)

//                    self.tfEmail.text = ""
                  //  GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"Reset email has been sent to your login email, please follow the instructions in the mail to reset your password")
                  
                }
            }
        }
    }
    func checkValidation()  {
        if tfEmail.text == "" {
            GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:"Please enter your email")
        } else {
            self.ResetPassword()
        }
    }
    func configureTextField() {
        tfEmail.delegate = self
        tfEmail.layer.cornerRadius = 27
        tfEmail.layer.borderWidth = 1
        tfEmail.layer.borderColor = UIColor(named: K.Colors.lightGrey)?.cgColor
        tfEmail.backgroundColor = .clear
        tfEmail.setLeftPaddingPoints(20)
        tfEmail.setRightPaddingPoints(20)
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        
        tfEmail.attributedPlaceholder = NSAttributedString(string: "University Email",
                                                                 attributes: [.foregroundColor: UIColor.lightGray,
                                                                              .font: UIFont(name: K.font, size: 14)!,
                                                                              .paragraphStyle: centeredParagraphStyle])
    }
    // MARK: - Navigation
    @IBAction func btnActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func btnActionSubmit(_ sender: Any) {
        self.checkValidation()
    }
    
}
//MARK: Extension_UiTextField
extension ResetPassword : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
