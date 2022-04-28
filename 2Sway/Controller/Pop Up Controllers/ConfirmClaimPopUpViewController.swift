//
//  ConfirmClaimPopUpViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 18/09/2021.
//

import UIKit

protocol ConfirmClaimDelegate: PromoViewController {
    func claimNowPressed(promo: Promos, viewCount: Int)
}

class ConfirmClaimPopUpViewController: UIViewController {
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var promo: Promos?
    var image: UIImage?
    var specificDiscount: Int = 0
    var viewCount: Int?
    var isDiscMain = String()
    var business: Business?
    var strBusiness = String()
    weak var delegate: ConfirmClaimDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        guard let promo = self.promo else {
            return
        }
        titleLabel.text = "Are you sure that you want to claim \(specificDiscount)% off \(promo.name)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2

        guard let promo = promo else {fatalError("Promo is nil")}
        popUpView.layer.cornerRadius = 10
        brandImage.image = image
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        DatabaseManager.shared.getUser { success in
            if success {
                print(AppData.shared.user!)
                DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
            }
        }
//        if self.isDiscMain == "0" {
//        } else if self.isDiscMain == "1" {
//            AppData.shared.user?.dataThisMonth.numberOfLowLevelDiscountClaimed += 1
//            AppData.shared.user?.dataThisMonth.totalNumberOfPromotions += 1
//            business?.totalNumberOfPromotions += 1
//            business?.numberOfDiscountsClaimedAtLowestLevel += 1
//        } else if self.isDiscMain == "2" {
//            AppData.shared.user?.dataThisMonth.numberOfMidLevelDiscountClaimed += 1
//            AppData.shared.user?.dataThisMonth.totalNumberOfPromotions += 1
//            business?.totalNumberOfPromotions += 1
//            business?.numberOfDiscountsClaimedAtMidLevel += 1
//        } else {
//            AppData.shared.user?.dataThisMonth.numberOfHighLevelDiscountClaimed += 1
//            AppData.shared.user?.dataThisMonth.totalNumberOfPromotions += 1
//            business?.totalNumberOfPromotions += 1
//            business?.numberOfDiscountsClaimedAtHighestLevel += 1
//        }        self.dismiss(animated: true)
       // self.dismiss(animated: true)
       // guard let promo = promo, let viewCount = viewCount, let delegate = delegate else { fatalError("delegate, Promo, or viewcount is nil")}
       // delegate.claimNowPressed(promo: promo, viewCount: viewCount)
        var indx = 0
        for i in AppData.shared.user!.promos {
            if i.businessID == self.strBusiness {
                AppData.shared.user?.promos[indx].isClaimed = true
                AppData.shared.user?.isExpire = ""
                DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
            }
           indx += 1
        }
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
