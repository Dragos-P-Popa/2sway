//
//  CacnelTrackingViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 17/09/2021.
//

import UIKit

class CancelTrackingViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2

        guard let img = image else {fatalError("Brand image is nil")}
        brandImage.image = img
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        var val = Int()
       
        if let busines = UserDefaults.standard.object(forKey:K.udefalt.Business) as? String {
            if busines == "" {
                GlobalAlert.showAlertMessage1(vc:self, titleStr:K.appName, messageStr:K.someWrong)
            } else {
//                for promo in AppData.shared.user!.promos {
//                    for j in promo.storyID {
//                        arryStories.append(j)
//                    }
//                }
//                var storyIds = AppData.shared.user!.storyIds
//                for k in 0..<arryStories.count {
//                    storyIds.removeAll(where: { $0 == arryStories[k] })
//                }
//                AppData.shared.user!.storyIds = storyIds
                for promo in AppData.shared.user!.promos {
                    if promo.businessID == busines {
                        AppData.shared.user?.promos.remove(at: val)
                        AppData.shared.user?.isExpire = ""
                        DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                        break
                    }
                    val += 1
                }
               // DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                UserDefaults.standard.removeObject(forKey:K.udefalt.Business)
                if let navVC = self.presentingViewController as? UINavigationController {
                    for vc in navVC.viewControllers {
                        if vc is HomeViewController {
                            navVC.popToViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey:K.udefalt.Business)
        self.dismiss(animated: true, completion: nil)
    }
}
