//
//  FinishPopUpViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 24/08/2021.
//

import UIKit

class FinishPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popUpImage: UIImageView!
    
    var claimedPromo: StudentPromos? // set in segue from Discount code VC
    var business: Business?
    var isIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        for business in AppData.shared.business {
            if business.name == self.claimedPromo?.businessID {
                self.business = business
                popUpImage.sd_setImage(with: URL(string: self.business!.logo), completed: nil)
            }
        }
        
        // view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }

    @IBAction func confirmButtonPressed(_ sender: UIButton) {
       // ActiveUser.activeUser.removeClaimedPromo(id: claimedPromo?.promoName)
        
        var index = isIndex
        for promo in AppData.shared.user!.promos {
            if promo.businessID == claimedPromo?.businessID {
                AppData.shared.user?.promos.remove(at: index)
                AppData.shared.user?.isExpire = ""
                UserDefaults.standard.set(false, forKey:"isTimeStart")
            }
            index += 1
        }
        DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
        self.dismiss(animated: true, completion: nil)
        if let navVC = self.presentingViewController as? UINavigationController {
            for vc in navVC.viewControllers {
                if vc is HomeViewController {
                    navVC.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
