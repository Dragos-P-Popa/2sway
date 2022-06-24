//
//  DiscountCodeController.swift
//  progressBar2
//
//  Created by user200155 on 8/18/21.
//

import UIKit
import FirebaseAnalytics

class DiscountCodeController: UIViewController {

    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discountCodeLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var brandImageView: UIImageView!

    
    
    var claimedPromoID: String?
    var business: Business?
    // Set local claimedPromo to the instance in ActiveUser which matches the promoID
    // Set in the viewDidLoad method
    var claimedPromo: StudentPromos?
    var CurrentPromo = String()
    let dateFormatter = DateFormatter()
    var timer: Timer?
    var totalSecond = Int()
    
  
    var isTimerRunning = false
    // Disable screen recording
    private let screenBlocker = ScreenBlocker()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                AnalyticsParameterScreenName: "discount"
            ])
        
        navigationItem.hidesBackButton = true
        let ProfilePic = AppData.shared.user?.urlString ?? ""
        if ProfilePic == "" || ProfilePic == nil {
          print("notFound")
        } else {
            profileIcon.sd_setImage(with: URL(string:(AppData.shared.user?.urlString)!), completed: nil)
        }
        nameLabel.text = AppData.shared.user?.name
        
        finishButton.layer.cornerRadius = finishButton.frame.height/2
        print("Dicount promo", claimedPromoID)
        for promo in AppData.shared.user!.promos {
            if promo.businessID == claimedPromoID {
                self.claimedPromo = promo
                self.CurrentPromo = promo.businessID
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Screen recording is disabled when discount code is on screen
        screenBlocker.startPreventingRecording()
        
        if let claimedPromo = claimedPromo {
            
            discountCodeLabel.text = "\(self.claimedPromo!.discount)% off \(self.claimedPromo!.promoName)"
            for business in AppData.shared.business {
                if business.name == self.claimedPromo?.businessID {
                    self.business = business
                }
            }
            brandImageView.sd_setImage(with: URL(string: self.business!.logo), completed: nil)
            print(self.claimedPromo!.promoName)
            print(self.claimedPromo!.businessID)
            // Create the timer to update the time remaining
            if let isTimeStart = UserDefaults.standard.object(forKey:"isTimeStart") as? Bool {
                if isTimeStart == true {
                    self.FetchTimer()
                } else {
                    self.StartMainTimer()
                }
            } else {
                self.StartMainTimer()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        
    }
    func StartMainTimer()  {
            let timeInterval = DateComponents(
                minute: 10
            )
            let timeInterval1 = DateComponents(
                
            )
            let CurrentDate = Calendar.current.date(byAdding: timeInterval1, to: Date())!
            
            let futureDate = Calendar.current.date(byAdding: timeInterval, to: Date())!
            print("\(CurrentDate.description(with: Locale(identifier: "en_US"))).")
            print("\(futureDate.description(with: Locale(identifier: "en_US"))).")
            UserDefaults.standard.set(futureDate, forKey:"futureDate")
            UserDefaults.standard.set(true, forKey:"isTimeStart")
            UserDefaults.standard.set(self.claimedPromo!.businessID, forKey:"PromoName")
            print(futureDate)
            let interval = futureDate - CurrentDate
            print(Double(interval.second!))
            var mainDouble = Double(interval.second!)
          
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] myTimer in
            guard let strongSelf = self else {return}
            mainDouble -= 1
            var val = Int()
            guard let timeRemainingText = mainDouble.format(using: [.minute, .second]) else { fatalError("Time remaining formatting failed") }
            strongSelf.countdownTimer.text = timeRemainingText
            print(Double(interval.second!))
            if mainDouble <= 0.0 {
                for promo in AppData.shared.user!.promos {
                    if promo.promoName == self!.claimedPromo!.promoName {
                        AppData.shared.user?.promos.remove(at: val)
                        AppData.shared.user?.isExpire = ""
                        break
                    }
                    val += 1
                }
                DatabaseManager.shared.uploadUser(user: AppData.shared.user!)

                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                    return
                }
                UserDefaults.standard.set(false, forKey:"isTimeStart")
                let navigationController = UINavigationController(rootViewController: rootVC)
                navigationController.navigationBar.isHidden = true
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                guard let ID = strongSelf.claimedPromoID else {fatalError("Claimed Promo ID is nil")}
//                ActiveUser.activeUser.removeClaimedPromo(id: ID)
//
//                guard let navVC = strongSelf.navigationController else { return }
//                for vc in navVC.viewControllers {
//                    if vc is MyClaimedPromosViewController {
//                        navVC.popToViewController(vc, animated: true)
//                    }
//                }
            }
        }
    }
    func FetchTimer() {
        if let getFuturDate = UserDefaults.standard.object(forKey:"futureDate") as? Date {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] myTimer in
                guard let strongSelf = self else {return}
                print(getFuturDate)
                //   let fu = getFuturDate.description(with: Locale(identifier: "en_US"))
                let timeInterval1 = DateComponents(
                )
                //guard let strongSelf = self else {return}
                let CurrentDate = Calendar.current.date(byAdding: timeInterval1, to: Date())!
                let interval = getFuturDate - CurrentDate
                UserDefaults.standard.set(self!.claimedPromo!.businessID, forKey:"PromoName")
                var mainDouble = Double(interval.second!)
                mainDouble -= 1
                guard let timeRemainingText = mainDouble.format(using: [.minute, .second]) else { fatalError("Time remaining formatting failed") }
                var val1 = Int()
                strongSelf.countdownTimer.text = timeRemainingText
                print(Double(interval.second!))
                if  Double(interval.second!) <= 0.0 {
                    for promo in AppData.shared.user!.promos {
                        if promo.businessID ==  self!.CurrentPromo {
                            AppData.shared.user?.promos.remove(at: val1)
                            AppData.shared.user?.isExpire = ""
                            break
                        }
                        val1 += 1
                    }
                    DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                    guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                        return
                    }
                    UserDefaults.standard.set(false, forKey:"isTimeStart")
                    let navigationController = UINavigationController(rootViewController: rootVC)
                    navigationController.navigationBar.isHidden = true
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    func createTimer() {
            var timeRemaining = 600.0

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] myTimer in
            guard let strongSelf = self else {return}
            timeRemaining -= 1
            guard let timeRemainingText = timeRemaining.format(using: [.minute, .second]) else { fatalError("Time remaining formatting failed") }
            strongSelf.countdownTimer.text = timeRemainingText

            if timeRemaining <= 0.0 {
                myTimer.invalidate()
                guard let ID = strongSelf.claimedPromoID else {fatalError("Claimed Promo ID is nil")}

                ActiveUser.activeUser.removeClaimedPromo(id: ID)
            
                guard let navVC = strongSelf.navigationController else { return }
                for vc in navVC.viewControllers {
                    if vc is MyClaimedPromosViewController {
                        navVC.popToViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FinishPopUpViewController {
            vc.claimedPromo = self.claimedPromo
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.toFinishPopUp, sender: self)
    }
}


extension Date {
//    static func - (lhs: Date, rhs: Date) -> TimeInterval {
//        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
//    }
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}
extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
}
