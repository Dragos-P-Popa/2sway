//
//  NotVerifiedViewController.swift
//  2Sway
//
//  Created by Joe Feest on 28/11/2021.
//

import UIKit
import Firebase
import MBProgressHUD


class NotVerifiedViewController: UIViewController {

    @IBOutlet weak var OKButton: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnResend.layer.cornerRadius = OKButton.frame.height / 2
        OKButton.layer.cornerRadius = OKButton.frame.height / 2
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnResendAgain(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.sendVerification()
    }
    func sendVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if error == nil {
                print("Verification email sent")
                MBProgressHUD.hide(for: self.view, animated: true)
                GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"Confirmation mail successfully sent again")
            } else {
                print("Verification email error")
                MBProgressHUD.hide(for: self.view, animated: true)
                GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:error?.localizedDescription ?? "")
                //print(error?.localizedDescription)
            }
        })
    }
}
