//
//  PromoInvalidPopUpViewController.swift
//  2Sway
//
//  Created by Joe Feest on 22/09/2021.
//

import UIKit

class PromoInvalidPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    
    var image: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        okButton.layer.cornerRadius = okButton.frame.height/2
        okButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)

        if let img = image {
            brandImage.sd_setImage(with: img, completed: nil)
        } else {
            let img = UIImage(named: K.ImageNames.swayBlack)
            brandImage.image = img
        }
        
    }
    
    @objc func okPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
