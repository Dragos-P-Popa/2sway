//
//  Constants.swift
//  progressBar2
//
//  Created by Joe Feest on 16/08/2021.
//

import CoreGraphics
import UIKit

struct K {
    
    static let font = "Jost"
    static let appName = "2Sway"
    static let someWrong = "Something went wrong , please try after sometime"
    static let animationTime = 1.0
    static let timeToVerify = 5.0 // Number of seconds between clicking "I've posted" and showing the progress bar
    static let refreshCheckInterval = 1.0 // Number of seconds between timer checking whether post has been "verifying" for long enough
    static let codeDuration: Double = 600 // number of seconds to redeem discount once code is shown
    static let promoAvailableDays: Double = 21 // Number of days a ClaimedPromo can be redeemed after claiming
    static let unpressableAlpha: CGFloat = 0.5
    
    struct udefalt {
        static let IsPhoto = "IsPhoto"
        static let IsRegister = "IsRegister"
        static let EmailCurrent = "EmailCurrent"
        static let UserIdMain = "UserIdMain"
        static let isLogin = "isLogin"
        static let isStart = "isStart"
        static let Business = "Business"
        static let ProPic = "ProPic"
    }
    
    struct ImageNames {
        static let downArrowWhite = "downArrowWhite"
        static let downArrowBlack = "downArrowBlack"
        static let leftArrowWhite = "leftArrowWhite"
        static let rightArrowBlack = "rightArrowBlack"
        static let leftArrowBlack = "leftArrowBlack"
        static let tickBlack = "tickBlack"
        static let upArrowBlack = "upArrowBlack"
        static let upArrowWhite = "upArrowWhite"
        static let myPromosIcon = "myPromosIcon"
        static let myProfileIcon = "myProfileIcon"
        static let myPromosWithNotif = "myPromosWithNotif"
        static let instaGlyph = "instaGlyph"
        static let swayBlack = "2SwayBlack"
    }
    
    struct SampleBrandLogos {
        static let distriktLogo = "distriktLogo"
        static let fullersLogo = "fullersLogo"
        static let greeneKingLogo = "greeneKingLogo"
        static let pixelBarLogo = "pixelBarLogo"
        static let revsLogo = "revsLogo"
    }
    
    struct Segues {
        static let toLogin = "toLogin"
        static let toTakePhoto = "toTakePhoto"
        static let toIntro = "toIntro"
        static let introToHome = "introToHome"
        static let logInToHome = "logInToHome"
        static let toSettings = "toSettings"
        static let toSelectedPromo = "toSelectedPromo"
        static let toRedeemable = "toRedeemable"
        static let toVerifiedPopUp = "toVerifiedPopUp"
        static let toHome = "toHome"
        static let toPromos = "toPromos"
        static let homeToClaimDiscount = "homeToClaimDiscount"
        static let toRules = "toRules"
        static let toTerms = "toTerms"
        static let toPrivacy = "toPrivacy"
        static let toDeletePopUp = "toDeletePopUp"
        static let toRedeemPopUp = "toRedeemPopUp"
        static let toRedeem = "toRedeem"
        static let toFinishPopUp = "toFinishPopUp"
        static let toHomeFromDiscount = "toHomeFromDiscount"
        static let toRetakePopUp = "toRetakePopUp"
        static let toRetakeCam = "toRetakeCam"
        static let isThisOkay = "isThisOkay"
        static let toHomeFromNewPic = "toHomeFromNewPic"
        static let cancelTrackingPopUp = "cancelTrackingPopUp"
        static let toPromoView = "toPromoView"
        static let toConfirmClaim = "toConfirmClaim"
        static let signOut = "signOut"
        static let toPromoInvalidPopUp = "toPromoInvalidPopUp"
    }
    
    struct Colors {
        static let black = "black"
        static let white = "white"
        static let darkGrey = "darkGrey"
        static let lightGrey = "lightGrey"
        static let offWhite = "offWhite"
        static let swayYellow = "2SwayYellow"
    }
    
    struct Cells {
        static let BrandCell = "BrandCell"
        static let PromoCell = "PromoCell"
        static let BrandDescCell = "BrandDescCell"
        static let SelectedPromoCell = "SelectedPromoCell"
        static let FurtherInfoCell = "FurtherInfoCell"
        static let FurtherInfoDetailCell = "FurtherInfoDetailCell"
        static let RedeemablePromoCell = "RedeemablePromoCell"
    }
    
    struct LoadingAnimation {
        static let minAlpha: CGFloat = 0.3
        static let maxAlpha: CGFloat = 1.0
    }
    
    struct Pointers {
        static let pointer1 = "1."
        static let pointer2 = "2."
        static let pointer3 = "3."
        static let pointer4 = "OK?"
    }
    
    struct SampleData {
        static let brandDesc = """
            [Intro: DJ Beats, MC Grindah]
            Rah, there's a dead MC on the floor
            Who's that standing above him?
            He's got a microphone and it's pointed in this direction
            I think it might be MC Grindah
            Who?
            MC Grindah
            """
    }
    
    struct Greetings {
        static let greetings = [
                                "What's tonight?",
        ]
    }
    struct Share {
        static let shareString = "Hey! This is an invite to 2Sway. It's a new app that gives you huge discounts on drinks & food at bars, clubs & restaurants in exchange for your Instagram story views. Search for 2Sway on the App Store, or you can download it here: https://apps.apple.com/gb/app/2sway-share-get-rewarded/id1607213123"
    }
    
    struct Database {
        
        struct collections {
            static let students = "Students"
        }
        
        struct details {
            static let name = "name"
            static let url = "urlString"
            static let totalPromos = "TotalPromosDone"
        }
    }
    
    static var userID: String? = UserDefaults.standard.string(forKey: "userID")
    static var cookieString: String? = UserDefaults.standard.string(forKey: "cookie")
    static var storyCount: Int? = 0
}

struct GlobalAlert {
    static func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        let alertAction = UIAlertAction(title: "ok", style: .cancel) { (alert) in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }
    static func showAlertMessage1(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        let alertAction = UIAlertAction(title: "ok", style: .cancel) { (alert) in
         //   vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
struct GlobalShare {
    static func ShareUrl(urlPath:String) {
        guard let url = URL(string:urlPath) else {
          return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
