//
//  ClaimDiscountViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 15/08/2021.
//

import UIKit

@IBDesignable class MyClaimedPromosViewController: UIViewController {
    
    // Will be set to true if "My Redeemable Promos" button is pressed on home screen so view controller can be popped when back button pressed
    var fromHomeViewController: Bool = false
    
    // Will be set when claim now button is pressed in Cell
    var claimedPromoID: String?
    
    var timer: Timer?
    var business: Business?
    
    @IBOutlet weak var redeemablePromosTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noPromosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redeemablePromosTable.dataSource = self
        redeemablePromosTable.delegate = self
        redeemablePromosTable.register(UINib(nibName: K.Cells.RedeemablePromoCell, bundle: nil), forCellReuseIdentifier: K.Cells.RedeemablePromoCell)
        self.redeemablePromosTable.reloadData()
      
        NotificationCenter.default.addObserver(self, selector: #selector(updateAvailablePromos), name: Notification.Name("promoRemoved"), object: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
         configureNavigationBar()
         print("Hello User", AppData.shared.user?.promos)
      
    }
    func repet(paramaeterName : String) {
        print(paramaeterName)
    }
    override func viewDidAppear(_ animated: Bool) {
        if (AppData.shared.user?.promos.count ?? 0) > 0 {
            noPromosLabel.isHidden = true
            
        } else {
            noPromosLabel.isHidden = false
        }
        self.redeemablePromosTable.reloadData()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in
//            self?.redeemablePromosTable.reloadData()
//        }
       // self.CheckPromoExpiry()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    func configureNavigationBar() {
        if fromHomeViewController == false {
            backButton.setImage(.init(systemName: "house"), for: .normal)
        }
    }
//    func CheckPromoExpiry() {
//        let todayDate = Date().string(format: "dd-MMM-yyyy")
//        
//        if (AppData.shared.user?.promos.count ?? 0) > 0 {
//            noPromosLabel.isHidden = true
//            var index = 0
//            for promo in AppData.shared.user!.promos {
//                print(promo.ExpireDate)
//                if todayDate > promo.ExpireDate || promo.ExpireDate == "" {
//                    AppData.shared.user?.promos.remove(at: index)
//                }
//                index += 1
//                DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
//                if (AppData.shared.user?.promos.count ?? 0) > 0 {
//                    noPromosLabel.isHidden = true
//                } else {
//                    noPromosLabel.isHidden = false
//                }
//            }
//        } else {
//            noPromosLabel.isHidden = false
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RedeemPopUpViewController {
            vc.claimedPromoID = self.claimedPromoID
        }
        if let vc = segue.destination as? DiscountCodeController {
            vc.claimedPromoID = self.claimedPromoID
        }
    }

    @IBAction func backButton(_ sender: Any) {
        if fromHomeViewController {
            navigationController?.popViewController(animated: true)
            fromHomeViewController = false // reset to default value of not coming from home VC
        } else {
        performSegue(withIdentifier: K.Segues.toHome, sender: self)
        }
    }
    
    @objc func updateAvailablePromos() {
      //  redeemablePromosTable.reloadData()
    }
}

extension MyClaimedPromosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.user?.promos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let redeemablePromoCell = tableView.dequeueReusableCell(withIdentifier: K.Cells.RedeemablePromoCell, for: indexPath)
            as! RedeemablePromoCell
        redeemablePromoCell.configure(with: (AppData.shared.user?.promos[indexPath.row])!)
        redeemablePromoCell.delegate = self
        return redeemablePromoCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 231 / 342
    }
    
}

extension MyClaimedPromosViewController: RedeemablePromoCellDelegate {
    
    func redeemButtonPressed(claimedPromo: StudentPromos) {
        
        // Match up the local instance of the claimed promo to the promo stored in the ActiveUser class, then assign attributes
        print(AppData.shared.user!.promos)
        for promo in AppData.shared.user!.promos {
            if promo.businessID == claimedPromo.businessID {
                self.claimedPromoID = promo.businessID
            }
        }
        if claimedPromo.isClaimed {
            performSegue(withIdentifier: K.Segues.toRedeemPopUp, sender: self)
        } else {
            var val = Int()
            var selectedPromo: [Promos]?
            var aryBuines = [String]()
            for business in AppData.shared.business {
                aryBuines.append(business.name)
            }
            print(selectedPromo)
                for i in 0..<AppData.shared.business.count {
                    if selectedPromo == nil  {
                    for business in AppData.shared.business {
                        print(aryBuines[i])
                        print(claimedPromo.businessID )
                        if business.name == claimedPromo.businessID {
                            self.business = business
                            print(business.name)
                            print(claimedPromo.promoName)
                            selectedPromo = business.promos.filter({ _ in business.name == claimedPromo.businessID })
                            print(selectedPromo)
                            val = i
                        }
                    }
                }
            }
            for promo in AppData.shared.user!.promos {
                if promo.businessID == business?.name {
                    break
                }
                val += 1
                print(val)
            }
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "promoVC") as! PromoViewController
            vc.business = self.business
            vc.image = nil
            vc.selectedPromo = selectedPromo![0]
            vc.studentPromo = claimedPromo
            print(val)
            vc.IntIndex = val
            vc.isAgain = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showCodeButtonPressed(claimedPromo: StudentPromos) {
        
        // Match up the local instance of the claimed promo to the promo stored in the ActiveUser class, then assign attributes
        for promo in AppData.shared.user!.promos {
            if promo.promoName == claimedPromo.promoName {
                
                // synchronise local claimedPromo with instance in ActiveUser for segue
                self.claimedPromoID = promo.promoName
            }
        }
        
        performSegue(withIdentifier: K.Segues.toRedeem, sender: self)
    }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
