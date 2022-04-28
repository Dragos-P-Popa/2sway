//
//  RedeemPopUpViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 24/08/2021.
//

import UIKit

class RedeemPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popUpImage: UIImageView!
    
    var claimedPromoID: String?
    var claimedPromo: StudentPromos? // set in viewDidLoad
    var business: Business?
    var inDId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        for promo in AppData.shared.user!.promos {
            if promo.businessID == claimedPromoID {
                self.claimedPromo = promo
            }
        }
        for business in AppData.shared.business {
            if business.name == self.claimedPromo!.businessID {
                self.business = business
            }
        }
        popUpImage.sd_setImage(with: URL(string: business!.logo), completed: nil)
        popUpView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        
        // Match up the local instance of the claimed promo to the promo stored in the ActiveUser class, then assign attributes
        for promo in ActiveUser.activeUser.myPromos {
            if promo!.promoID == claimedPromoID {
                promo!.isRedeemed = true
                promo!.timeRedeemed = Date()
            }
        }
        DatabaseManager.shared.uploadLocalClaimedPromos()
        
        // Segue out of ClaimDiscountVC after popup is dismissed
        let childControllers = self.presentingViewController?.children
        var pvc: MyClaimedPromosViewController?
        for vc in childControllers! {
            if vc is MyClaimedPromosViewController {
                pvc = (vc as! MyClaimedPromosViewController)
            }
        }
        self.dismiss(animated: true) {
            pvc!.performSegue(withIdentifier: K.Segues.toRedeem, sender: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

