//
//  DeletePopUpViewController.swift
//  progressBar2
//
//  Created by user201027 on 9/2/21.
//

import UIKit
import Firebase

class DeletePopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        
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
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
