//
//  ConfirmPicViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 16/09/2021.
//

import UIKit
import MBProgressHUD

class ConfirmPicViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var newImage: UIImage?
    
    override func viewDidLoad() {
        popUpView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
    
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let image = newImage else { return }
        profileImage.image = image
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        guard let image = newImage, let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to data")
            return
        }
        NotificationCenter.default.post(name: Notification.Name("NotificationProgress1"), object: nil, userInfo:nil)
        DatabaseManager.shared.uploadImageData(data: imageData)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion : { NotificationCenter.default.post(name: Notification.Name("restartCamera"), object: nil)})
    }
}
