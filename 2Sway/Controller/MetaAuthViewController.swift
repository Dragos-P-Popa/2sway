//
//  MetaAuthViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 25/07/2022.
//

import Foundation
import FacebookLogin

class MetaAuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.permissions = ["instagram_basic", "pages_show_list"]
        view.addSubview(loginButton)
        
        if let token = AccessToken.current,
            !token.isExpired {
            let obj = self.storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
            //self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
