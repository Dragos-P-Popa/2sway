//
//  WelcomeController.swift
//  progressBar2
//
//  Created by Joe Feest on 23/07/2021.
//

import UIKit
import Firebase
import MBProgressHUD

class AMSleepTimerUtil: NSObject {
    static let shared = AMSleepTimerUtil()
    fileprivate var sleepTimer: Timer?
    weak var timer: Timer?
    
    /// Initialize the timer to trigger a function to execute after a duration of time
    /// - Parameter seconds: the time delay until the selector function executes
    /// - Returns: true if sleep timer were successfully initialized
//    func createTimerToStopMusic(at seconds: TimeInterval) -> Bool {
//        let fireAtDate = Date(timeIntervalSinceNow: seconds)
//        stopSleepTimer()
//
//        self.sleepTimer = Timer(fireAt: fireAtDate,
//                                interval: 0,
//                                target: self,
//                                selector: #selector(pauseMusic),
//                                userInfo: nil,
//                                repeats: false)
//        guard let sleepTimer = sleepTimer else { return false }
//        RunLoop.main.add(sleepTimer, forMode: .common)
//        return true
//    }
//
//    @objc func pauseMusic() {
//
//    }
    
    /// Used to reset the sleep timer before initializing a new timer if the user clicks the "Set Timer" multiple times
    func stopSleepTimer() {
        if sleepTimer != nil {
            sleepTimer?.invalidate()
            sleepTimer = nil
        }
    }
    
    func sleepTimerIsActive() -> Bool {
        return self.sleepTimer != nil
    }
}
class HomeViewController: UIViewController {
    
    let brandBrain = BrandBrain()
    var brandSelected: Business?
    var invalidBrandImage: URL?
    var timer: Timer?
    var timer1: Timer?
    let refreshControl = UIRefreshControl()
    var check = Reachability()
    var isAnyActive = Bool()
    var appVersionCurent = String()
    var appOldVersion = String()
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var brandTableView: UITableView!
    @IBOutlet weak var myProfileButton: UIButton!
    @IBOutlet weak var myPromosButton: UIButton!
    
    // Builds list of random brands of arbitrary length
  //  var brands: [Brand] {return brandBrain.buildBrandList()}
    var businesses: [Business] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bgTask = UIBackgroundTaskIdentifier(rawValue: 10)
            bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(bgTask)
            })
        
        //refreshing user
        DatabaseManager.shared.getUser(completion: { success in })
        
        var emailMain = String()
        if let emailGet = UserDefaults.standard.object(forKey:K.udefalt.EmailCurrent) {
            if "\(emailGet)" == "" {
                emailMain = ""
            } else {
                emailMain = "\(emailGet)"
            }
        }
        
    
        let docRef = DatabaseManager.shared.db.collection("Students").document(emailMain)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                /*if document.get("accountStatus") as! Int == 0 {
                    
                    let alert = UIAlertController(title: "Account found", message: "Continue", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                    self.present(alert, animated: true, completion: nil)
                      
                }*/
                if document.get("accountStatus") != nil {
                    if document.get("accountStatus") as! Int == 1 {
                        docRef.setData(["accountStatus" : 0], merge: true)
                        
                        let alert = UIAlertController(title: "Account management", message: "There has been an error with your account. You will be signed out, please try to signin again.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.signout()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    if document.get("accountStatus") as! Int == 2 {
                        docRef.setData(["accountStatus" : 0], merge: true)
                        
                        let alert = UIAlertController(title: "Account management", message: "There has been an undefined error with your account. Your account will be deleted, please try to register again.\n \nIf you have any questions please contact example@2sway.com", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.deleteUser()
                            docRef.delete()
                            self.signout()
                        }))
                        self.present(alert, animated: true, completion: nil)
                         
                        
                    }
                }
            }
        }
        /*
        let profCheck = Firestore.firestore()
            .collection("Students").whereField("email", isEqualTo:emailMain)
        
        // Get data
        profCheck.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }  else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                if let dictMain = dataDescription as? NSDictionary {
                    if let proPic = dictMain.object(forKey:"urlString") {
                        if self.proPic == "" {
                            guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "isPhoto") as? TakePhotoViewController else {
                                return
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let navigationController = UINavigationController(rootViewController: rootVC)
                            navigationController.navigationBar.isHidden = true
                            UserDefaults.standard.set(false, forKey:K.udefalt.IsPhoto)
                            UserDefaults.standard.set(true, forKey:K.udefalt.IsRegister)
                            UIApplication.shared.windows.first?.rootViewController = navigationController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        } else {
                            UserDefaults.standard.set(true, forKey:K.udefalt.isLogin)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.performSegue(withIdentifier: K.Segues.logInToHome, sender: self)
                        }
                        AppData.shared.user = UserModel(accountStatus:self.accountStatus, email:self.strEmail, name:self.strname, isExpire:self.isExpire, urlString:self.strProfileUrl, dataThisMonth:DataThisMonth(), totalEngagements:self.IntTotleng, promos:self.aryPromoMain, instagram:self.strInsta, storyIds:self.aryStoryIds)
                        DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                        DatabaseManager.shared.getUser(completion: { success in
                            
                        })
                    }
                }
            }
        }
         */
        
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                AnalyticsParameterScreenName: "home"
            ])
        
        let currentUser = Auth.auth().currentUser;
        if (currentUser == nil) {
            signout()
        }
        
       // print(AMSleepTimerUtil.shared.createTimerToStopMusic(at:1))
        brandTableView.dataSource = self
        brandTableView.delegate = self
        brandTableView.register(UINib(nibName: K.Cells.BrandCell, bundle: nil), forCellReuseIdentifier: K.Cells.BrandCell)
//        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(getStories), userInfo: nil, repeats: true)
//        timer!.fireDate = .init(timeIntervalSinceNow: 0)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        brandTableView.addSubview(refreshControl) // not required when using UITableViewController
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        appVersionCurent = appVersion!.replacingOccurrences(of: ".", with: "")
        print(appVersion ?? "")
     
        
        DatabaseManager.shared.db.collection("Businesses").getDocuments() { documents, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                do{
                    for document in documents!.documents {
                        print("Firebase data ", document.data())
                        let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                        let business = try JSONDecoder().decode(Business.self, from: data)
                        self.businesses.append(business)
                        print("Hello business ", business)
                        self.brandTableView.reloadData()
                    }
                    AppData.shared.business = self.businesses
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func checkForAppVersionUpdate(CurentVersion:String,LiveVersion:String) {
        
        if CurentVersion > LiveVersion {
            let alert=UIAlertController(title:"Older Version", message: "Your current version is older please upgrade new version with more features", preferredStyle:UIAlertController.Style.alert )

            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {
                    _ in
                if let url = URL(string: "https://apps.apple.com/us/app/2sway-share-get-rewarded/id1607213123"),
                    UIApplication.shared.canOpenURL(url)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
            present(alert, animated: true, completion: nil)

        }
    }
    func startTimer() {
           timer1?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
           timer1 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
               if self?.check.isConnectedToNetwork() == true {
                   GlobalAlert.showAlertMessage(vc:self!, titleStr:K.appName, messageStr:"your internet connection has been restored")
                   MBProgressHUD.hide(for:self!.view, animated:true)
                   self?.stopTimer()
               }
           }
       }

       func stopTimer() {
           timer1?.invalidate()
       }
    
    func deleteUser() {
            
            let user = Auth.auth().currentUser
            ActiveUser.activeUser.deleteData()

            user?.delete { error in
                if let error = error {
                print("Error occurred in deleting account: \(error)")
              } else {
                print("Account deleted")
                
                guard let navVC = self.presentingViewController?.presentingViewController?.presentingViewController as? UINavigationController else { return }
                
                navVC.dismiss(animated: true, completion: nil)
                            
                let firstVC = navVC.viewControllers.first
                if firstVC is SignUpViewController {
                    navVC.popToRootViewController(animated: true)

                } else {
                    firstVC?.performSegue(withIdentifier: K.Segues.signOut, sender: self)
                }
              }
            }
        }
    
    func signout() {
        do {
        try Auth.auth().signOut()
        print("User signed out")
        UserDefaults.standard.set(false, forKey:K.udefalt.isLogin)
        UserDefaults.standard.set(false, forKey:K.udefalt.IsRegister)
        UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
        UserDefaults.standard.removeObject(forKey:K.udefalt.EmailCurrent)
        UserDefaults.standard.removeObject(forKey:K.udefalt.Business)
        UserDefaults.standard.removeObject(forKey:K.udefalt.UserIdMain)
        UserDefaults.standard.set(false, forKey:"isTimeStart")
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        K.storyCount = 0
        K.userID = ""
        K.cookieString = ""
        AppData.shared.user = nil
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
    } catch let signOutError as NSError {
        print("Error signing out: \(signOutError)")
    }
    }
//    private func getWiFiRSSI() -> Int? {
//        let app = UIApplication.shared
//        var rssi: Int?
//        let exception = try {
//            guard let statusBar = app.value(forKey: "statusBar") as? UIView else { return }
//            if let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), statusBar .isKind(of: statusBarMorden) { return }
//
//            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return  }
//
//            for view in foregroundView.subviews {
//                if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view .isKind(of: statusBarDataNetworkItemView) {
//                    if let val = view.value(forKey: "wifiStrengthRaw") as? Int {
//                        rssi = val
//                        break
//                    }
//                }
//            }
//        }
//        if let exception = exception {
//            print("getWiFiRSSI exception: \(exception)")
//        }
//        return rssi
//    }
    @objc func refresh(_ sender: AnyObject) {
        DatabaseManager.shared.getUser { success in
            if success {
                if AppData.shared.user!.promos.count ?? 0 > 0 {
                    self.myPromosButton.setImage(UIImage(named: K.ImageNames.myPromosWithNotif), for: .normal)
                    self.CheckActivePromo()
                } else {
                    self.myPromosButton.setImage(UIImage(named: K.ImageNames.myPromosIcon), for: .normal)
                }
            }
        }
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        let greeting = K.Greetings.greetings.randomElement()
        greetingLabel.text = greeting
        
        // Synchronise local "myPromos" with firebase
        DatabaseManager.shared.updateLocalClaimedPromos { success in
            if success {
                print("Number of local promos = \(ActiveUser.activeUser.promos.count)")
                NotificationCenter.default.removeObserver(self, name: Notification.Name("restartCamera"), object: nil)
            }
        }
    }
    func CheckActivePromo() {
        for i in AppData.shared.user!.promos {
            if i.isClaimed == true {
                self.isAnyActive = true
            } else {
                self.isAnyActive = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MBProgressHUD.hide(for:self.view, animated:true)
           DatabaseManager.shared.getUser { success in
               if success {
                   if AppData.shared.user!.promos.count ?? 0 > 0 {
                       self.myPromosButton.setImage(UIImage(named: K.ImageNames.myPromosWithNotif), for: .normal)
                       self.CheckActivePromo()
                   } else {
                       self.myPromosButton.setImage(UIImage(named: K.ImageNames.myPromosIcon), for: .normal)
                   }
               }
           }
    }
    override func viewDidDisappear(_ animated: Bool) {
        //timer?.invalidate()
    }
    
    private func configureNavigationBar() {
        myPromosButton.addTarget(self, action: #selector(myPromosIconPressed), for: .touchUpInside)
        myProfileButton.addTarget(self, action: #selector(profileIconPressed), for: .touchUpInside)
    }
    
    @objc func profileIconPressed() {
        performSegue(withIdentifier: K.Segues.toSettings, sender: self)
    }
    
    @objc func myPromosIconPressed() {
        performSegue(withIdentifier: K.Segues.homeToClaimDiscount, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PromoSelectionViewController {
            vc.brand = self.brandSelected
        }
        if let vc = segue.destination as? MyClaimedPromosViewController {
            vc.fromHomeViewController = true
        }
        if let vc = segue.destination as? PromoInvalidPopUpViewController {
            vc.image = invalidBrandImage
        }
    }
    
//    @objc func getStories() {
//        APIClient().getStoryCount(data: K.cookieString ?? "", userID: K.userID ?? "") { storyCount, storyId in
//            DispatchQueue.main.async {
//                print("Hello Stories ", storyCount)
//                K.storyCount = storyCount
//            }
//        } fail: { error in
//            DispatchQueue.main.async {
//                let vc = WebViewViewController()
//                vc.delegate = self
//                vc.modalPresentationStyle = .formSheet
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
//    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath)
            as! BrandCell
        
        cell.configure(with: businesses[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 203 / 342
    }
}

extension HomeViewController: BrandCellDelegate {
    func brandPressed(brand: Business) {
        
        let currentUser = Auth.auth().currentUser;
        if (currentUser == nil) {
            let alert = UIAlertController(title: "Account exception", message: "There has been an error with your account. You will be signed out, please try to login or register again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                    do {
                    try Auth.auth().signOut()
                    print("User signed out")
                    UserDefaults.standard.set(false, forKey:K.udefalt.isLogin)
                    UserDefaults.standard.set(false, forKey:K.udefalt.IsRegister)
                    UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
                    UserDefaults.standard.removeObject(forKey:K.udefalt.EmailCurrent)
                    UserDefaults.standard.removeObject(forKey:K.udefalt.Business)
                    UserDefaults.standard.removeObject(forKey:K.udefalt.UserIdMain)
                    UserDefaults.standard.set(false, forKey:"isTimeStart")
                  //  UserDefaults.standard.set(false, forKey:K.udefalt.IsPhoto)
                 //   guard let navVC = presentingViewController as? UINavigationController else { return }
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    K.storyCount = 0
                    K.userID = ""
                    K.cookieString = ""
                    AppData.shared.user = nil
                    HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                    guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
                        return
                    }
                    let navigationController = UINavigationController(rootViewController: rootVC)
                    navigationController.navigationBar.isHidden = true
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                } catch let signOutError as NSError {
                    print("Error signing out: \(signOutError)")
                }
                }))
            self.present(alert, animated: true, completion: nil)
    }
    
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        currentUser?.reload { error in
            if !currentUser!.isEmailVerified {
                self.performSegue(withIdentifier: K.Segues.toVerifiedPopUp, sender: self)
                return
            }  else {
                if self.check.isConnectedToNetwork() == true {
                    if ((AppData.shared.user?.promos.isEmpty) != nil) {
                        self.brandSelected = brand
                        //   let vc = BusinessDetailsViewController()
                        let obj = self.storyboard?.instantiateViewController(withIdentifier:"BusinessDetailsViewController") as! BusinessDetailsViewController
                        //  let promo = AppData.shared.user?.promos
                        
                        if ((AppData.shared.user?.promos.isEmpty) != nil) {
                            for claimedPromo in AppData.shared.user!.promos {
                                if claimedPromo.businessID == brand.name {
                                    self.invalidBrandImage = URL(string: brand.logo)
                                    self.performSegue(withIdentifier: K.Segues.toPromoInvalidPopUp, sender: self)
                                    return
                                }
                            }
                        }
                        if AppData.shared.user?.promos.count ?? 0 > 0 && self.isAnyActive == false {
                            Analytics.logEvent("duplicatePromotions", parameters: [
                                "Description": "You already have one active promotions.You must cancel that promotion before you can do another one." as NSObject
                            ])
                            GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"You already have one active promotions.You must cancel that promotion before you can do another one.")
                        } else {
                          //  MBProgressHUD.showAdded(to: self.view, animated: true)
                            obj.business = brand
                            self.navigationController?.pushViewController(obj, animated: true)
                        }
                    } else {
                        if ((AppData.shared.user?.promos.isEmpty) != nil) {
                            for claimedPromo in AppData.shared.user!.promos {
                                if claimedPromo.businessID == brand.name {
                                    self.invalidBrandImage = URL(string: brand.logo)
                                    self.performSegue(withIdentifier: K.Segues.toPromoInvalidPopUp, sender: self)
                                    return
                                }
                            }
                        }
                        self.brandSelected = brand
                     //   let vc = BusinessDetailsViewController()
                        let obj = self.storyboard?.instantiateViewController(withIdentifier:"BusinessDetailsViewController") as! BusinessDetailsViewController
                        obj.business = brand
                        self.navigationController?.pushViewController(obj, animated: true)
                    }
                } else {
                    let loadingNotification = MBProgressHUD.showAdded(to:self.view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    loadingNotification.label.text = "check your network connection!"
                    self.startTimer()
                }
            }
        }
    }
}
extension HomeViewController: WebViewCotrollerDelegate {
    func hideView() {
//        APIClient().getStoryCount(data: K.cookieString ?? "", userID: K.userID ?? "") { storyCount, storyId in
//            DispatchQueue.main.async {
//                K.storyCount = storyCount
//            }
//        } fail: { error in
//            DispatchQueue.main.async {
//                let vc = WebViewViewController()
//                vc.delegate = self
//                vc.modalPresentationStyle = .formSheet
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
        DispatchQueue.main.async {
            let vc = WebViewViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        }
    }
}
//    
//else if K.cookieString?.isEmpty ?? true {
//    DispatchQueue.main.async {
//        let vc = WebViewViewController()
//        vc.delegate = self
//        vc.modalPresentationStyle = .formSheet
//        self.present(vc, animated: true, completion: nil)
//    }
//}


//                    if promo?.count ?? 0 > 0 {
//                        for i in promo ?? [] {
//                            if i.promoName == brand.name {
//                                GlobalAlert.showAlertMessage(vc:self, titleStr:K.appName, messageStr:"You either have an active promotion or discount waiting for you at this business already! Finish your active promotion or redeem your discount in order to promote this business again.")
//                                break
//                            } else {
//                                obj.business = brand
//                                self.navigationController?.pushViewController(obj, animated: true)
//                            }
//                        }
//                    } else {
//                        obj.business = brand
//                        self.navigationController?.pushViewController(obj, animated: true)
//                    }
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    } }
extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
extension HomeViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
