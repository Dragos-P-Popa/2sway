//
//  RedeemablePromoCell.swift
//  progressBar2
//
//  Created by Joe Feest on 15/08/2021.
//

import UIKit

protocol RedeemablePromoCellDelegate: MyClaimedPromosViewController {
    func redeemButtonPressed(claimedPromo: StudentPromos)
    func showCodeButtonPressed(claimedPromo: StudentPromos)
}

class RedeemablePromoCell: UITableViewCell  {
       
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var showCodeButton: UIButton!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var promoDetails: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var roundedView: UIView!
    
    var claimedPromo: StudentPromos?
    var business: Business?
    
    weak var delegate: RedeemablePromoCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set spacing between cells
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16))
        
        redeemButton.layer.cornerRadius = redeemButton.frame.height/2
        showCodeButton.layer.cornerRadius = showCodeButton.frame.height/2

        roundedView.layer.cornerRadius =  10

    }
    
    func configure(with claimedPromo: StudentPromos) {
        
        // Match up the local instance of the claimed promo to the promo stored in the ActiveUser class, then assign attributes
        statusLabel.isHidden = true
        for promo in AppData.shared.user!.promos {
            print(promo.promoName , claimedPromo.businessID , claimedPromo.promoName)
            if promo.businessID == claimedPromo.businessID {
                self.claimedPromo = promo
            }
        }
        for business in AppData.shared.business {
            if business.name == self.claimedPromo?.businessID {
                self.business = business
                break
            }
        }
        brandImage.sd_setImage(with: URL(string: business!.logo), completed: nil)
        brandName.text = self.business?.name
        if claimedPromo.isClaimed {
            promoDetails.text = "\(self.claimedPromo!.discount)% off \(self.claimedPromo!.promoName)"
        } else {
            promoDetails.text = "Active Promotion"
        }
        if claimedPromo.isClaimed {
            redeemButton.setTitle("Redeem now", for: .normal)
        } else {
            redeemButton.setTitle("Go to promotion", for: .normal)
        }
        recalculateTimeRemaining()
    }
    
    func recalculateTimeRemaining() {
//        guard let claimedPromo = self.claimedPromo else { return }
//        guard let formattedTimeremaining = claimedPromo.formatAdaptiveTimeRemaining(timeRemaining: claimedPromo.timeRemainingToRedeem()) else { fatalError("Error formatting date string") }
//        statusLabel.text = "Valid Until: \(formattedTimeremaining)."
//
//        if claimedPromo.timeRemainingToRedeem() < 0 {
//            let id = claimedPromo.promoID
//            ActiveUser.activeUser.removeClaimedPromo(id: id)
//            NotificationCenter.default.post(name: Notification.Name("promoRemoved"), object: nil)
//        }
    }
    
    @IBAction func redeemButtonPressed(_ sender: UIButton) {
        if claimedPromo!.isClaimed == false {
            delegate?.redeemButtonPressed(claimedPromo: claimedPromo!)
        } else {
            if let checkTimer = UserDefaults.standard.object(forKey:"isTimeStart") as? Bool {
                if checkTimer == true {
                    if let checkPromo = UserDefaults.standard.object(forKey:"PromoName") as? String {
                        if "\(checkPromo)" == business!.name {
                            delegate?.redeemButtonPressed(claimedPromo: claimedPromo!)
                        } else {
                            let alert = UIAlertController(title:K.appName, message:"Your " + "\(checkPromo)" + " Reedem Promo alreday Running", preferredStyle: UIAlertController.Style.alert);
                            let alertAction = UIAlertAction(title: "ok", style: .cancel) { (alert) in
                                    UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController?.dismiss(animated:true, completion:nil)
                            }
                            alert.addAction(alertAction)
                            UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        delegate?.redeemButtonPressed(claimedPromo: claimedPromo!)
                    }
                } else {
                    delegate?.redeemButtonPressed(claimedPromo: claimedPromo!)
                }
            } else {
                delegate?.redeemButtonPressed(claimedPromo: claimedPromo!)
            }
        }
    }
    
    @IBAction func showCodeButtonPressed(_ sender: UIButton) {
        delegate?.showCodeButtonPressed(claimedPromo: claimedPromo!)
    }
}
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
