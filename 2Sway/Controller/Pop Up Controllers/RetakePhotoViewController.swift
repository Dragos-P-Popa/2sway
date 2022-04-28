//
//  RetakePhotoViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 16/09/2021.
//

import UIKit
import MBProgressHUD

class RetakePhotoViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        popUpView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        super.viewDidLoad()

    }
    @IBAction func confirmPressed(_ sender: UIButton) {
      //  MBProgressHUD.showAdded(to: self.view, animated: true)
        self.dismiss(animated: false, completion: { NotificationCenter.default.post(name: Notification.Name("goToRetake"), object: nil) })
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
