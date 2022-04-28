//
//  PromoViewController.swift
//  progressBar2
//
//  Created by user201027 on 8/9/21.
//

import UIKit
import Alamofire
import WaveAnimationView

class PromoViewController: UIViewController, ProgressBarDelegate, ConfirmClaimDelegate ,NetworkSpeedProviderDelegate {
   
    func callWhileSpeedChange(networkStatus: NetworkStatus) {
        switch networkStatus {
        case .poor:
            break
        case .good:
            break
        case .disConnected:
            break
        }
    }
        
    let test = NetworkSpeedTest()
    var check = Reachability()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var promoTitle: UILabel!
    @IBOutlet weak var ivePostedBackground: RoundedUIView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var informationText: UILabel!
    @IBOutlet weak var ivePostedButton: UIButton!
    @IBOutlet weak var claimNowButton: UIButton!
    @IBOutlet weak var buttonText: UILabel!
    @IBOutlet weak var offsetRing: RoundedUIView!
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(gray: 0, alpha: 1),
                           CGColor(gray: 0, alpha: 0.3),
                           CGColor(gray: 0, alpha: 0)]
        gradient.locations = [0, 0.4, 1]
        return gradient
    }()
    var isDisk = String()
    var StrCurentBusines = String()
    var selectedPromo: Promos?
    var business: Business?
    var wave: WaveAnimationView!

    let progressBar = ProgressBar()
    private var timeVerified: Date?
    private var isClaimable: Bool = false
    var specificDiscount = 0
    var image: UIImage?
    var storyID: String?
    var storyCount: Int?
    var studentPromo: StudentPromos?
    var InstaIds = [String]()
    var timer: Timer?
    @IBOutlet weak var lblCount: UILabel!
    var apiClas = APIClient()
    var mainStorycount = Int()
    var mainStoryId = Int()
    var isAgain = Bool()
    var IntIndex = Int()
    @IBOutlet weak var viewAni: UIView!
    //  var localUrl = "http://192.168.1.123/2way/story/"
    //"http://77.68.72.78/story/"
   var localUrl = "http://77.68.72.78/story/"
    private weak var displayLink: CADisplayLink?
    private var isVerifying: Bool = false {
        didSet {
            if isVerifying {
                startDisplayLink()
            } else {
                stopDisplayLink()
            }
        }
    }
    
    // needed for reference when leaving this view controller
 //   var initialInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: ivePostedButton.bounds.size), color: UIColor(named: "2SwayYellow")!.withAlphaComponent(0.5))
        
       // self.viewAni.backgroundColor = UIColor.green
        self.ivePostedButton.addSubview(wave)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(ivePostedPressed))
        wave.addGestureRecognizer(gesture)
       // self.viewAni.addSubview(wave)
        wave.setProgress(0.0)
        wave.startAnimation()
       // self.ivePostedButton.addSubview(self.viewAni)
        progressBar.delegate = self
        ivePostedButton.addTarget(self, action: #selector(lineThicken), for: .touchDown)
        ivePostedButton.addTarget(self, action: #selector(ivePostedPressed), for: .touchUpInside)
        ivePostedButton.addTarget(self, action: #selector(lineThinnen), for: .touchDragOutside)
        let height = claimNowButton.frame.height
        claimNowButton.layer.cornerRadius = height/2
        offsetRing.layer.borderWidth = 5
        offsetRing.layer.borderColor = UIColor.black.cgColor
        offsetRing.isHidden = true
        
        if studentPromo != nil {
            // Here comes the code to directly animate
            buttonText.text = "See your views"
        } else {
            buttonText.text = "I've posted"
        }
      
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
       print("test")
    }
    
    override func viewDidAppear(_ animated: Bool) {
       if self.isAgain == false {
            if check.isConnectedToNetwork() == true {
                if K.cookieString == nil {
                    DispatchQueue.main.async {
                        let vc = WebViewViewController()
                        vc.delegate = self
                        vc.modalPresentationStyle = .formSheet
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
                let uiAlert = UIAlertController(title: "Error!", message: "Please check your network connection!", preferredStyle: UIAlertController.Style.alert)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                 }))
                self.present(uiAlert, animated: true, completion: nil)
            }
        }
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                    return
                }
                let navigationController = UINavigationController(rootViewController: rootVC)
                navigationController.navigationBar.isHidden = true
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
        //self.lblCount.text = "500"
        guard let promo = selectedPromo else { fatalError("Selected promo is nil") }
        configurePrePress(with: promo)
        if isAgain == true {
          //  self.configureAfterPress()
        }
        
//        if let checkStart = UserDefaults.standard.object(forKey:K.udefalt.isStart) as? Bool {
//            if checkStart == true {
//                isVerifying = true
//                backButton.isHidden = true
//
//                informationText.text = """
//                    We are just verifying that everything checks out with your post. Don’t worry, you’ll still be rewarded for the views you are getting in the meantime!
//                    """
//                progressBar.lowViews = selectedPromo!.lowestView
//                progressBar.midViews = selectedPromo!.middleView
//                progressBar.highViews = selectedPromo!.highestView
//                progressBar.lowDiscount = selectedPromo!.lowestDiscount
//                progressBar.midDiscount = selectedPromo!.middleDiscount
//                progressBar.highDiscount = selectedPromo!.highestDiscount
//
//                // Upload promo to Firebase to allow manual verification
//                guard let promo = selectedPromo else { fatalError("Selected promo is nil") }
//                let verifyingPromo = VerifyingPromo(brandID: promo.name, promoID: promo.name)
//                DatabaseManager.shared.uploadVerifyingPromo(verifyingPromo: verifyingPromo)
//
//                animateVerifyShow()
//
//                timeVerified = Date().addingTimeInterval(TimeInterval(K.timeToVerify))
//
//                createTimer()
//            }
//        }
    }
   
    func FutureDate() -> String {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 2
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print(currentDate)
        print(futureDate!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from:futureDate!)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringDate = formatter.string(from: yourDate!)
        return myStringDate
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        gradient.frame = brandImage.frame
    }
    
    func configurePrePress(with promo: Promos) {
        if image != nil {
            brandImage.image = image
        } else {
            brandImage.sd_setImage(with: URL(string: business!.logo), completed: nil)
            image = brandImage.image
        }
        promoTitle.text = promo.name
        statusText.text = "Maximum discount: \(Int(promo.highestDiscount))% off"
    }
    
    // Back button functionality
    @IBAction func backButtonPressed(_ sender: UIButton) {
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        guard let navVC = navigationController else { fatalError("Nav VC is nil.")}
//        for vc in navVC.viewControllers {
//            if vc is PromoSelectionViewController || vc is MyClaimedPromosViewController {
//                navVC.popToViewController(vc, animated: true)
//            }
//        }
    }
    
    @objc func lineThicken() {
        self.offsetRing.layer.borderWidth = 10
        self.offsetRing.layer.borderColor = UIColor.green.cgColor
    }
    
    @objc func lineThinnen() {
        self.offsetRing.layer.borderWidth = 5
        self.offsetRing.layer.borderColor = UIColor.green.cgColor

    }
    
    @objc func ivePostedPressed() {
//        test.delegate = self
//        test.networkSpeedTestStop()
//        test.networkSpeedTestStart(UrlForTestSpeed: "https://tariqalwasel.com/story/getStories.php")
        if check.isConnectedToNetwork() == true {
            lineThinnen()
            configureAfterPress()
        } else {
            let uiAlert = UIAlertController(title: "Error!", message: "Please check your network connection!", preferredStyle: UIAlertController.Style.alert)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
             }))
            self.present(uiAlert, animated: true, completion: nil)
            AppData.shared.business
        }
    }
    
    func configureAfterPress() {
        if check.isConnectedToNetwork() == true {
            lineThinnen()
            if K.cookieString?.isEmpty ?? true || K.cookieString == "" {
                let vc = WebViewViewController()
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true, completion: nil)
            } else {
                isVerifying = true
                //backButton.isHidden = true
                informationText.text = """
                    We are just verifying that everything checks out with your post. Don’t worry, you’ll still be rewarded for the views you are getting in the meantime!
                    """
                progressBar.lowViews = selectedPromo!.lowestView
                progressBar.midViews = selectedPromo!.middleView
                progressBar.highViews = selectedPromo!.highestView
                progressBar.lowDiscount = selectedPromo!.lowestDiscount
                progressBar.midDiscount = selectedPromo!.middleDiscount
                progressBar.highDiscount = selectedPromo!.highestDiscount
                // Upload promo to Firebase to allow manual verification
                guard let promo = selectedPromo else { fatalError("Selected promo is nil") }
               // let verifyingPromo = VerifyingPromo(brandID: promo.name, promoID: promo.name)
                //DatabaseManager.shared.uploadVerifyingPromo(verifyingPromo: verifyingPromo)
                animateVerifyShow()
                var EmailMain = String()
                var EmailMain1 = String()
                if let email = UserDefaults.standard.object(forKey:K.udefalt.EmailCurrent) {
                    EmailMain = "\(email)"
                } else {
                    EmailMain = ""
                }
                if let UserIdMain = UserDefaults.standard.object(forKey:K.udefalt.UserIdMain) {
                    EmailMain1 = "\(UserIdMain)"
                } else {
                    EmailMain1 = K.userID ?? ""
                }
                let businessName = business?.name.capitalized
                let parameters = [
                    "userId":EmailMain1,
                    "coockies":K.cookieString ?? "", "email":EmailMain, "businessId":businessName ?? ""
                    ] as [String : Any]
                print(parameters)
                var urlString = String()
                if isAgain == true {
                    urlString = localUrl + "updatecount.php"
                } else {
                    urlString = localUrl + "getStories.php"
                }
                self.apiClas.getStoryCount1(urlMain:urlString, parametersInsta:parameters) { sCount, SIds,instaId,isExpire   in
                    print(sCount,SIds)
                    if sCount == "-1" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "We’ve had a problem getting your story views. Make sure you have posted a story and included the venue’s location tag", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                self.backButton.isHidden = false
                                self.animateVerifyHide()
                            }))
                           // self.ivePostedButton.setTitle("", for:.normal)
                            self.lblCount.text = ""
                            self.ivePostedButton.setTitle("I've Posted", for: .normal)
                            self.wave.setProgress(0.0)
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else if sCount == "-2" {
                        DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message:SIds, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                            self.backButton.isHidden = false
                            self.animateVerifyHide()
                        }))
                       // self.ivePostedButton.setTitle("", for:.normal)
                            self.claimNowButton.setTitle("Cancel", for: .normal)
                            self.claimNowButton.alpha = K.unpressableAlpha
                        self.lblCount.text = ""
                        self.ivePostedButton.setTitle("I've Posted", for: .normal)
                            self.wave.setProgress(0.0)
                        self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            K.storyCount = Int(sCount)
                            if AppData.shared.user?.storyIds.count ?? 0 > 0 {
                                var dupData = [String]()
                                self.InstaIds = AppData.shared.user?.storyIds ?? []
                              //  self.InstaIds.append(instaId)
                                for i in instaId {
                                    dupData.append(i)
                                }
                                print(dupData)
                                self.InstaIds = dupData.removingDuplicates()
                                print(self.InstaIds)
                            } else {
                                self.InstaIds = instaId
                                 print(self.InstaIds)
                            }
                            
                          //  self.storyID = instaId
                            self.storyCount = Int(sCount)

//                            } else {
                                if Int(sCount)! < self.progressBar.lowViews {
                                    self.lblCount.text = "\(sCount) views, Current discount: 0%"
                                    if isExpire == true {
                                        let alert = UIAlertController(title: "Error", message: "Your story has either expired or been deleted. This means that your story views will no longer increase. Claim or cancel this promotion.", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                           // self.backButton.isHidden = false
                                            //self.animateVerifyHide()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    self.business?.totalEngagements = Int(sCount)!
                                    //  self.lblDiscout.text = "discount: 0%"
                                } else if Int(sCount)! < self.progressBar.midViews {
                                   
                                    self.lblCount.text = "\(sCount) views, Current discount: \(self.progressBar.lowDiscount)%"
                                    if isExpire == true {
                                        let alert = UIAlertController(title: "Error", message: "Your story has either expired or been deleted. This means that your story views will no longer increase. Claim or cancel this promotion.", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                            //self.backButton.isHidden = false
                                            //self.animateVerifyHide()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    AppData.shared.user?.storyIds = instaId
                                    self.business?.totalEngagements = Int(sCount)!
                                    //  self.lblDiscout.text = "discount: \(self.progressBar.lowDiscount)%"
                                } else if Int(sCount)! < self.progressBar.highViews {
                                    self.lblCount.text = "\(sCount) views, Current discount: \(self.progressBar.midDiscount)%"
                                    if isExpire == true {
                                        let alert = UIAlertController(title: "Error", message: "Your story has either expired or been deleted. This means that your story views will no longer increase. Claim or cancel this promotion.", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                           // self.backButton.isHidden = false
                                           // self.animateVerifyHide()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    AppData.shared.user?.storyIds = instaId
                                    self.business?.totalEngagements = Int(sCount)!
                                    //self.lblDiscout.text = "discount: \(self.progressBar.midDiscount)%"
                                } else {
                                    self.lblCount.text = "\(sCount) views, Current discount: \(self.progressBar.highDiscount)%"
                                    if isExpire == true {
                                        let alert = UIAlertController(title: "Error", message: "Your story has either expired or been deleted. This means that your story views will no longer increase. Claim or cancel this promotion.", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                           // self.backButton.isHidden = false
                                           // self.animateVerifyHide()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    self.business?.totalEngagements = Int(sCount)!
                                    AppData.shared.user?.storyIds = instaId
                                    //self.lblDiscout.text = "discount: \(self.progressBar.highDiscount)%"
                                }
                                self.isAgain = true
                                self.buttonText.text = ""
                                self.mainStorycount = Int(sCount) ?? 0
                                self.animateVerifyHide()
                                self.animateProgressShow()
                            //
                        }
                    }
                } fail: { error in
                    GlobalAlert.showAlertMessage(vc: self, titleStr:K.appName, messageStr:error?.localizedDescription ?? "Failed to Get Story")
                }
            }
        } else {
            let uiAlert = UIAlertController(title: "Error!", message: "Please check your network connection!", preferredStyle: UIAlertController.Style.alert)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
             }))
            self.present(uiAlert, animated: true, completion: nil)
        }
        
      //  timeVerified = Date().addingTimeInterval(TimeInterval(K.timeToVerify))
        //createTimer()
    }
    
    
//    func createTimer() {
//        //progressBar.viewCount = 5
//        let _ = Timer.scheduledTimer(withTimeInterval: K.refreshCheckInterval, repeats: true) { timer in
//            // Check whether enough time has elapsed
//            if Date() > self.timeVerified! {
//                self.isVerifying = false
//                timer.invalidate()
//                self.animateVerifyShow()
//                // self.progressBar.viewCount = K.storyCount ?? 0
//
//                DatabaseManager.shared.checkVerifyingPromo { isVerified in
//                    if let isVerified = isVerified {
//                        if isVerified {
//                            self.getStoryCount()
//                            self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.updateStoryCount), userInfo: nil, repeats: true)
//                            self.timer!.fireDate = .init(timeIntervalSinceNow: 0)
//                        } else {
//                            print("Post is not verified")
//                        }
//                        DatabaseManager.shared.deleteVerifyingPromo()
//                    }
//                    // if isVerified is nil, then an error occurred in reading the verifyingPromo doc
//                    else {
//                        print("An error has occurred")
//                    }
//                }
//            }
//        }
//    }
    
    
//    func getStoryCount() {
//        APIClient().getStoryCount(data: K.cookieString ?? "", userID: K.userID ?? "") { storyCount, storyID in
//            DispatchQueue.main.async {
//                print("Hello Stories ", storyCount)
//                print("Hello StoriesID ", storyID)
//                if storyCount == -1 {
//                    self.lblCount.text = ""
//                    UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
//                    let alert = UIAlertController(title: "Error", message: "We’ve had a problem getting your story views. Make sure you have posted a story and included the venue’s location tag and have tagged @2swayuk", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
//                        self.backButton.isHidden = false
//                        self.lblCount.text = ""
//                        self.animateVerifyHide()
//                    }))
//                    
//                    self.present(alert, animated: true, completion: nil)
//                }
//                else {
//                    K.storyCount = storyCount
//                    self.storyID = storyID
//                    self.storyCount = storyCount
//                    var currentPromo: StudentPromos?
//                    print(AppData.shared.user!.promos)
////                    for promo in AppData.shared.user!.promos {
////                        print(promo.storyID)
////                        if promo.storyID == storyID {
////                            currentPromo = promo
////                            break
////                        }
////                    }
//                    if AppData.shared.user!.storyIds.contains(storyID) {
//                        if (currentPromo?.isClaimed ?? true) || (currentPromo?.promoName ?? "") != self.selectedPromo?.name || (currentPromo?.businessID ?? "") != self.business?.name {
//                            UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
//                            let alert = UIAlertController(title: "Error", message: "You have already redeemed a discount using the story you’ve posted. You must post a new story at the venue", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
//                                self.animateVerifyHide()
//                                self.backButton.isHidden = false
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        } else {
//                            self.animateVerifyHide()
//                            self.animateProgressShow()
//                            self.buttonText.text = ""
//                           // storyCount = 500
//                            print(self.progressBar.lowDiscount)
//                           // self.progressBar.viewCount = 500
//                            print(self.progressBar.lowViews,self.progressBar.highViews,self.progressBar.midViews)
//                          //  self.lblCount.text = String(storyCount)
//                          //  self.updatePromosList(isClaimed: false)
//                            if storyCount < self.progressBar.lowViews {
//                                self.lblCount.text = "\(storyCount) views, Current discount: 0%"
//                            } else if storyCount < self.progressBar.midViews {
//                                self.lblCount.text = "\(storyCount) views, Current discount: \(self.progressBar.lowDiscount)%"
//                            } else if storyCount < self.progressBar.highViews {
//                                self.lblCount.text = "\(storyCount) views, Current discount: \(self.progressBar.midDiscount)%"
//                            } else {
//                                self.lblCount.text = "\(storyCount) views, Current discount: \(self.progressBar.highDiscount)%"
//                            }
//                        }
//                    } else {
//                        self.animateVerifyHide()
//                        self.animateProgressShow()
//                        //storyCount = 500
//                        print(self.progressBar.highDiscount)
//                        self.buttonText.text = ""
//                        print(self.progressBar.lowViews,self.progressBar.highViews,self.progressBar.midViews)
//                      //  self.progressBar.viewCount = 500
//                      //  self.updatePromosList(isClaimed: false)
//                       // self.lblCount.text = String(storyCount)
//                        if storyCount < self.progressBar.lowViews {
//                            self.lblCount.text = "\(storyCount) views, Current discount: 0%"
//                          //  self.lblDiscout.text = "discount: 0%"
//                        } else if storyCount < self.progressBar.midViews {
//                            self.lblCount.text = "\(storyCount) views, Current discount: \(self.progressBar.lowDiscount)%"
//                          //  self.lblDiscout.text = "discount: \(self.progressBar.lowDiscount)%"
//                        } else if storyCount < self.progressBar.highViews {
//                            self.lblCount.text = "\(storyCount) views, Current discount: \(self.progressBar.midDiscount)%"
//                            self.progressBar
//                           // self.lblDiscout.text = "discount: \(self.progressBar.midDiscount)%"
//                        } else {
//                            self.lblCount.text = "\(storyCount) views, Current discount: \(self.progressBar.highDiscount)%"
//                            //self.lblDiscout.text = "discount: \(self.progressBar.highDiscount)%"
//                        }
//                    }
//                    print("Hello Stories found", storyCount)
//                }
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
  
//    @objc func updateStoryCount() {
//        if self.storyCount != nil {
//            APIClient().getStoryCount(data: K.cookieString ?? "", userID: K.userID ?? "") { storyCount, storyID in
//                DispatchQueue.main.async {
//                    if storyID == self.storyID {
//                        self.storyCount = storyCount
//                        self.progressBar.viewCount = storyCount
//                        print("Hello story count", self.storyCount)
//                     //   self.updatePromosList(isClaimed: false)
//                     //   self.updatePromosList(isClaimed:false, discount:, sCount: storyCount)
//                    }
//                }
//            } fail: { error in
//                DispatchQueue.main.async {
//                    let vc = WebViewViewController()
//                    vc.delegate = self
//                    vc.modalPresentationStyle = .formSheet
//                    self.present(vc, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//
    // Fade in Verifiying view
    func animateVerifyShow() {
        
        self.buttonText.alpha = 0.0
        self.buttonText.text = "Verifying..."
        self.ivePostedButton.isHidden = true
        
        UIView.animate(withDuration: K.animationTime, animations: {

            self.buttonText.alpha = 1.0
            self.ivePostedBackground.backgroundColor = UIColor(named: K.Colors.lightGrey)
        })
    }
    
    func animateVerifyHide() {
        
        self.buttonText.alpha = 0.0
       // self.buttonText.text = "I've Posted"
        self.ivePostedButton.isHidden = false
    //    self.ivePostedButton.setTitle("I've Posted", for: .normal)
        
        UIView.animate(withDuration: 0.1, animations: {

            self.buttonText.alpha = 0.0
            self.ivePostedBackground.backgroundColor = UIColor(named: "2SwayYellow")
        })
    }
    
    // Refresh animation at same rate as display refresh (60Hz or whatever)
    private func startDisplayLink() {
        stopDisplayLink() // stop previous display link if one happens to be running
        
        let link = CADisplayLink(target: self, selector: #selector(loadingAnimation))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
    }
    
    var alphaValue: CGFloat = 1.0
    var invert: Bool = false
    @objc func loadingAnimation() {
        
        invert ? (alphaValue -= 0.005) : (alphaValue += 0.005) // If invert is true then minus 1, otherwise add 1
      //  ivePostedBackground.alpha = alphaValue
        
        if alphaValue > K.LoadingAnimation.maxAlpha || alphaValue < K.LoadingAnimation.minAlpha {
            invert = !invert
        }
    }
    
    // Fade in progress bar and Redeem button
    func animateProgressShow() {
        
        UIView.animate(withDuration: K.animationTime, animations: {
            self.ivePostedBackground.addSubview(self.progressBar)
            self.progressBar.draw(self.ivePostedBackground.bounds)
            print(self.storyCount ?? 0)
            //self.storyCount = 422
            let mainValue = self.storyCount! * 100 / self.progressBar.highViews
            let getFloat = Float(mainValue)
//            if self.storyCount ?? 0 > 0 {
//                if getFloat == 0 {
//                    self.wave.setProgress(0.5)
//                    self.wave.startAnimation()
//                } else if getFloat > 0 && getFloat < 20.0{
//                    self.wave.setProgress(0.6)
//                    self.wave.startAnimation()
//                } else if getFloat > 20.0 && getFloat < 40.0 {
//                    self.wave.setProgress(0.7)
//                    self.wave.startAnimation()
//                } else if getFloat > 40.0 && getFloat < 60.0 {
//                    self.wave.setProgress(0.8)
//                    self.wave.startAnimation()
//                } else if getFloat > 60.0 && getFloat < 80.0 {
//                    self.wave.setProgress(0.9)
//                    self.wave.startAnimation()
//                } else {
//                    self.wave.setProgress(1.0)
//                    self.wave.startAnimation()
//                }
//            }
           // self.progressBar.viewCount = 3
            self.progressBar.viewCount = self.mainStorycount
            self.claimNowButton.setTitle("Cancel", for: .normal)
            self.claimNowButton.alpha = K.unpressableAlpha
            self.ivePostedBackground.backgroundColor = .clear
            self.ivePostedBackground.alpha = 1.0
            self.informationText.text = """
                    Claim whenever you want to stop us from monitoring your story. Remember that once you claim it, you’ll have to post again to get more discounts!
                    """
        })
        
        if mainStorycount >= selectedPromo!.lowestView {
            makeClaimable()
        }
    }
    
    func makeClaimable() {
        claimNowButton.setTitle("Claim Now", for: .normal)
        isClaimable = true
        claimNowButton.alpha = 1.0
        //DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
    }
    
    @IBAction func increaseViews(_ sender: UIButton) {
        progressBar.viewCount += 20
    }
    
    @IBAction func claimNowButtonPressed(_ sender: UIButton) {
        
        switch claimNowButton.title(for: .normal) {
        case "How To Guide":
          //  let vc = SplashRulesViewController()
//            vc.backButton.setImage(UIImage(named: K.ImageNames.downArrowWhite), for: .normal)
//            vc.business = business
//            vc.modalPresentationStyle = .fullScreen
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"RulesVC") as! RulesVC
            present(vc, animated: true, completion: nil)
        case "Cancel":
            print("API switched off etc.")
            //self.dismiss(animated: true, completion: nil)
            print(business!.name.capitalized)
            UserDefaults.standard.set(business!.name.capitalized, forKey:K.udefalt.Business)
            performSegue(withIdentifier: K.Segues.cancelTrackingPopUp, sender: self)
        case "Claim Now":
            if isClaimable {
                progressBar.viewCount = self.mainStorycount
                if progressBar.viewCount < selectedPromo!.lowestView {
                    self.specificDiscount = 0
                    isDisk = "0"
                } else if progressBar.viewCount < selectedPromo!.middleView {
                    self.specificDiscount = selectedPromo!.lowestDiscount
                    AppData.shared.user?.dataThisMonth.numberOfLowLevelDiscountClaimed += 1
                    AppData.shared.user?.dataThisMonth.totalNumberOfPromotions += 1
                  //  business?.totalNumberOfPromotions += 1
                  //  business?.totalEngagements += 1
                    business?.numberOfDiscountsClaimedAtLowestLevel += 1
                    isDisk = "1"
                } else if progressBar.viewCount < selectedPromo!.highestView {
                    self.specificDiscount = selectedPromo!.middleDiscount
                    AppData.shared.user?.dataThisMonth.numberOfMidLevelDiscountClaimed += 1
                    AppData.shared.user?.dataThisMonth.totalNumberOfPromotions += 1
                   // business?.totalNumberOfPromotions += 1
                  //  business?.totalEngagements += 1
                    business?.numberOfDiscountsClaimedAtMidLevel += 1
                   
                    isDisk = "1"
                } else {
                    self.specificDiscount = selectedPromo!.highestDiscount
                    AppData.shared.user?.dataThisMonth.numberOfHighLevelDiscountClaimed += 1
                    AppData.shared.user?.dataThisMonth.totalNumberOfPromotions += 1
                   // business?.totalNumberOfPromotions += 1
                    business?.numberOfDiscountsClaimedAtHighestLevel += 1
                 //   business?.totalEngagements += 1
                    isDisk = "2"
                }
                self.StrCurentBusines = business?.name ?? ""
                performSegue(withIdentifier: K.Segues.toConfirmClaim, sender: self)
            }
        default:
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CancelTrackingViewController {
            vc.image = image
            guard let promo = self.selectedPromo else { return }
        }
        
        if let vc = segue.destination as? ConfirmClaimPopUpViewController {
            DatabaseManager.shared.getUser { success in
                if success {
                    AppData.shared.user?.promos[0].isClaimed = true
                    AppData.shared.user?.promos[0].discount = self.specificDiscount
                }
            }
            vc.delegate = self
            vc.promo = self.selectedPromo
            vc.strBusiness = self.StrCurentBusines
            vc.specificDiscount = specificDiscount
            vc.business = business
            vc.isDiscMain = isDisk
            vc.viewCount = progressBar.viewCount
            vc.image = image
            
        }
    }
    
    func claimNowPressed(promo: Promos, viewCount: Int) {
       
    
        // Select the correct discount code based on percentageOff
        var discountCode: String {
            switch self.specificDiscount {
            case promo.lowestDiscount:
                return "\(promo.lowestDiscount)% off \(promo.name)"
            case promo.middleDiscount:
                return "\(promo.middleDiscount)% off \(promo.name)"
            case promo.highestDiscount:
                return "\(promo.highestDiscount)% off \(promo.name)"
            default:
                return "No Discount Found"
            }
        }
      //  updatePromosList(isClaimed: true)
       
     //   updatePromosList(isClaimed:true, discount:specificDiscount, sCount:viewCount, instaId:self.InstaIds)
    }
    
    func updatePromosList(isClaimed: Bool , discount : Int , sCount: Int , instaId : [String]) {
        let ExpireFutureDate = FutureDate()
        let claimedPromo = StudentPromos(businessID: business!.name, promoName: selectedPromo!.name, discount: discount, isClaimed: isClaimed, storyID:self.InstaIds, storyCount: sCount , totalEngagements: sCount)
        
        AppData.shared.user?.storyIds = instaId

        var shouldAdd = true
        if !isClaimed {
            for promo in AppData.shared.user!.promos {
                if promo.businessID == claimedPromo.businessID {
                    shouldAdd = false
                } else {
                    shouldAdd = true
                    break
                }
            }
            if shouldAdd {
                if isAgain == true {
                    print(self.IntIndex)
                    print(AppData.shared.user?.promos)
                    AppData.shared.user?.promos.remove(at:IntIndex)
                    print(AppData.shared.user?.promos)
                    AppData.shared.user?.promos.insert(claimedPromo, at:IntIndex)
                  //  DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                    print(AppData.shared.user?.promos)
                } else {
                    AppData.shared.user?.promos.append(claimedPromo)
                   // DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
                    print(AppData.shared.user?.promos.count)
                    self.IntIndex = (AppData.shared.user?.promos.count)!
                    isAgain = true
                }
            //    AppData.shared.user?.promos.append(claimedPromo)
//                if !AppData.shared.user!.storyIds.contains(storyID!) {
//                    AppData.shared.user?.storyIds.append(storyID ?? "")
//                }
            } else {
                var index = 0
                for promo in AppData.shared.user!.promos {
                    if promo.promoName == claimedPromo.promoName {
                        AppData.shared.user?.promos[index].storyCount = mainStorycount
                        AppData.shared.user?.promos[index].totalEngagements = mainStorycount
                        break
                    }
                    index += 1
                }
            }
        } else {
           // let index = (AppData.shared.user?.promos.count)! - 1
            AppData.shared.user?.promos[0].isClaimed = true
            AppData.shared.user?.promos[0].discount = self.specificDiscount
        }
//        if !isClaimed {
//            for promo in AppData.shared.user!.promos {
//                if promo.businessID == claimedPromo.businessID {
//                    var index = 0
//                    for promo in AppData.shared.user!.promos {
//                        if promo.promoName == claimedPromo.promoName {
//                            AppData.shared.user?.promos[index].storyCount = mainStorycount
//                            AppData.shared.user?.promos[index].totalEngagements = mainStorycount
//                            break
//                        }
//                        index += 1
//                    }
//                }
//            } else {
//                    if isAgain == true {
//                        print(AppData.shared.user?.promos)
//                        AppData.shared.user?.promos.remove(at:IntIndex)
//                        print(AppData.shared.user?.promos)
//                        AppData.shared.user?.promos.insert(claimedPromo, at:IntIndex)
//                        print(AppData.shared.user?.promos)
//                        break
//                    } else {
//                        AppData.shared.user?.promos.append(claimedPromo)
//                        print(AppData.shared.user?.promos.count)
//                        self.IntIndex = (AppData.shared.user?.promos.count)! + 1
//                      //  isAgain = true
//                    }
//                    if !AppData.shared.user!.storyIds.contains(storyID!) {
//                        AppData.shared.user?.storyIds.append(storyID ?? "")
//                    }
//                }
//            }
//        } else {
//            let index = (AppData.shared.user?.promos.count)! - 1
//            AppData.shared.user?.promos[index].isClaimed = true
//            AppData.shared.user?.promos[index].discount = self.specificDiscount
//        }
        do {
            try DatabaseManager.shared.db.collection(K.Database.collections.students).document((AppData.shared.user?.email)!).setData(from: AppData.shared.user) { error in
                if let e = error {
                    print("Issue saving data: \(e)")
                } else {
                    if isClaimed {
                        self.performSegue(withIdentifier: K.Segues.toRedeemable, sender: self)
                    }
                    print("Successfully saved data")
                    DatabaseManager.shared.updateBusiness(businessID: self.business!.name, business: self.business!)
                   // print(AppData.shared.user)
                 //   DatabaseManager.shared.uploadUser(user: AppData.shared.user!)
              }
            }
        } catch(let error) {
            print("Catch error", error)
        }
        
    }
}

extension PromoViewController: WebViewCotrollerDelegate {
    func hideView() {
//        APIClient().getStoryCount(data: K.cookieString ?? "", userID: K.userID ?? "") { storyCount, storyID in
//            DispatchQueue.main.async {
//                print("Hello Stories ", storyCount)
//                if storyCount == -1 {
//                    let alert = UIAlertController(title: "Error", message: "We’ve had a problem getting your story views. Make sure you have posted a story and included the venue’s location tag and have tagged @2swayuk", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//                else {
//                    print("Hello Stories found", storyCount)
//                }
//           }
//        } fail: { error in
//            DispatchQueue.main.async {
//                let vc = WebViewViewController()
//                vc.delegate = self
//                vc.modalPresentationStyle = .formSheet
//                //self.present(vc, animated: true, completion: nil)
//            }
//        }
    }
}
extension String {
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
}
    

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
//                            var currentPromo: StudentPromos?
//                            print(AppData.shared.user!.promos)
//                            for promo in AppData.shared.user!.promos {
//                                print(promo.storyID)
//                                if promo.storyID == self.storyID {
//                                    currentPromo = promo
//                                    break
//                                }
//                            }
////                            if AppData.shared.user!.storyIds.contains(instaId) {
//                                if (currentPromo?.isClaimed ?? true) || (currentPromo?.promoName ?? "") != self.selectedPromo?.name || (currentPromo?.businessID ?? "") != self.business?.name {
//                                    UserDefaults.standard.set(false, forKey:K.udefalt.isStart)
//                                    let alert = UIAlertController(title: "Error", message: "You have already redeemed a discount using the story you’ve posted. You must post a new story at the venue", preferredStyle: UIAlertController.Style.alert)
//                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
//                                        self.animateVerifyHide()
//                                        self.backButton.isHidden = false
//                                    }))
//                                    self.present(alert, animated: true, completion: nil)
//                                } else {
//
//                                    if Int(sCount)! < self.progressBar.lowViews {
//                                        self.lblCount.text = "\(sCount) views, Current discount: 0%"
//                                        //  self.lblDiscout.text = "discount: 0%"
//                                    } else if Int(sCount)! < self.progressBar.midViews {
//                                        self.lblCount.text = "\(sCount) views, Current discount: \(self.progressBar.lowDiscount)%"
//                                        //  self.lblDiscout.text = "discount: \(self.progressBar.lowDiscount)%"
//                                    } else if Int(sCount)! < self.progressBar.highViews {
//                                        self.lblCount.text = "\(sCount) views, Current discount: \(self.progressBar.midDiscount)%"
//                                        // self.lblDiscout.text = "discount: \(self.progressBar.midDiscount)%"
//                                    } else {
//                                        self.lblCount.text = "\(sCount) views, Current discount: \(self.progressBar.highDiscount)%"
//                                        //self.lblDiscout.text = "discount: \(self.progressBar.highDiscount)%"
//                                    }
//                                    self.mainStorycount = Int(sCount) ?? 0
//                                    self.animateVerifyHide()
//                                    self.animateProgressShow()
//                                    self.updatePromosList(isClaimed: false)
//
//                                }
