//
//  BusinessDetailsViewController.swift
//  2Sway
//
//  Created by Abhishek Dubey on 22/01/22.
//

import UIKit
import MBProgressHUD
import FirebaseAnalytics

class BusinessDetailsViewController: UIViewController {
    
    var business: Business?
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var imgInsta: UIImageView!
    @IBOutlet weak var btnDiscount: UIButton!
    @IBOutlet weak var btnMainBack: UIButton!
    
//    let backButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .clear
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: K.ImageNames.leftArrowBlack)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = .red
//        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
//        return button
//    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = ""
        label.font = UIFont(name: "JostRoman-SemiBold", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "$$"
        label.font = UIFont(name: "JostRoman-SemiBold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    let keywordsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "$$"
        label.font = UIFont(name: "JostRoman-SemiBold", size: 14)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    let closesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Closes at"
        label.textColor = .white
        label.font = UIFont(name: "JostRoman-SemiBold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "JostRoman-Regular", size: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

//    let openLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.text = "Open"
//        label.font = UIFont(name: "HelveticaNeue", size: 14)
//        label.textAlignment = .center
//        return label
//    }()
    
//    let closeTimeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .gray
//        label.text = "Closes at"
//        label.font = UIFont(name: "HelveticaNeue", size: 14)
//        label.textAlignment = .center
//        return label
//    }()
    
    let instagramImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: K.ImageNames.instaGlyph)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
        
    }()
    
    let instagramLinkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        return button
    }()
    
    let getDiscountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.titleLabel?.font =  UIFont(name: "JostRoman-SemiBold", size: 16)
        button.setTitle("Get Your Discount", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(getDiscountButtonTapped), for: .touchUpInside)
      //  button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        if UIDevice.current.hasNotch == true {
//            addConstraints2()
//        } else{
//            addConstraints()
//        }
        
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
//                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
//                    return
//                }
//                let navigationController = UINavigationController(rootViewController: rootVC)
//                navigationController.navigationBar.isHidden = true
//                UIApplication.shared.windows.first?.rootViewController = navigationController
//                UIApplication.shared.windows.first?.makeKeyAndVisible()
                self.navigationController?.popViewController(animated:true)
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
       // configureViews()
    }
    override func viewDidAppear(_ animated: Bool) {
     //   addViews()
     //   addConstraints()
        configureViews()
        Analytics.logEvent("business_viewed", parameters: [
            "business" : business?.name ?? "?"
            ])
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//           swipeRight.direction = .right
//           self.view.addGestureRecognizer(swipeRight)
//        MBProgressHUD.hide(for: self.view, animated: true)
//
//
     //   let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
      //      edgePan.edges = .right

       //     view.addGestureRecognizer(edgePan)
    }
  
    @objc func backButtonPressed() {
//        let window = UIWindow(windowScene: windowScene)
//        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        let navigationController = UINavigationController.init(rootViewController: homeVC)
//        navigationController.setNavigationBarHidden(true, animated: false)
//        window.rootViewController = navigationController
      //  self.navigationController?.popViewController(animated: true)
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @objc func openInstagram() {
        guard let url = URL(string: "https://www.instagram.com/\(business!.instagram)") else {
            UIApplication.shared.open(URL(string: "https://www.instagram.com")!)
            return
        }
        UIApplication.shared.open(url)
    }
    
    @objc func getDiscountButtonTapped() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "promoSelectionVC") as! PromoSelectionViewController
        vc.brand = business
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addViews() {
        let views = [imageView, titleLabel, priceLabel, clockImageView, closesLabel, keywordsLabel, descriptionLabel, instagramImageView, instagramLinkButton, getDiscountButton]
        views.forEach({ view.addSubview($0) })
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
                                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
                                      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                      imageView.heightAnchor.constraint(equalToConstant: 208),
                                      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 9),
                                      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                      priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
                                      closesLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
                                      closesLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 7),
                                      clockImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
                                      clockImageView.heightAnchor.constraint(equalToConstant: 14),
                                      clockImageView.widthAnchor.constraint(equalToConstant: 14),
                                      clockImageView.centerYAnchor.constraint(equalTo: closesLabel.centerYAnchor),
                                      keywordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      keywordsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                      keywordsLabel.topAnchor.constraint(equalTo: closesLabel.bottomAnchor, constant: 13),
                                      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                      descriptionLabel.topAnchor.constraint(equalTo: keywordsLabel.bottomAnchor, constant: 13),
//                                      openLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
//                                     openLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//                                      closeTimeLabel.centerYAnchor.constraint(equalTo: openLabel.centerYAnchor),
//                                      closeTimeLabel.leadingAnchor.constraint(equalTo: openLabel.trailingAnchor, constant: 5),
                                      instagramImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      instagramImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 27),
                                      instagramImageView.heightAnchor.constraint(equalToConstant: 19),
                                      instagramImageView.widthAnchor.constraint(equalToConstant: 19),
                                      instagramLinkButton.leadingAnchor.constraint(equalTo: instagramImageView.trailingAnchor, constant: 20),
                                      instagramLinkButton.centerYAnchor.constraint(equalTo: instagramImageView.centerYAnchor),
                                      getDiscountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                                      getDiscountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      getDiscountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                      getDiscountButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    func addConstraints2() {
        NSLayoutConstraint.activate([
                                      imageView.topAnchor.constraint(equalTo: view.topAnchor),
                                      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                      imageView.heightAnchor.constraint(equalToConstant: 208),
                                      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 9),
                                      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                      priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
                                      closesLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
                                      closesLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 7),
                                      clockImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
                                      clockImageView.heightAnchor.constraint(equalToConstant: 14),
                                      clockImageView.widthAnchor.constraint(equalToConstant: 14),
                                      clockImageView.centerYAnchor.constraint(equalTo: closesLabel.centerYAnchor),
                                      keywordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      keywordsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                      keywordsLabel.topAnchor.constraint(equalTo: closesLabel.bottomAnchor, constant: 13),
                                      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                      descriptionLabel.topAnchor.constraint(equalTo: keywordsLabel.bottomAnchor, constant: 13),
//                                      openLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
//                                     openLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//                                      closeTimeLabel.centerYAnchor.constraint(equalTo: openLabel.centerYAnchor),
//                                      closeTimeLabel.leadingAnchor.constraint(equalTo: openLabel.trailingAnchor, constant: 5),
                                      instagramImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      instagramImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 27),
                                      instagramImageView.heightAnchor.constraint(equalToConstant: 19),
                                      instagramImageView.widthAnchor.constraint(equalToConstant: 19),
                                      instagramLinkButton.leadingAnchor.constraint(equalTo: instagramImageView.trailingAnchor, constant: 20),
                                      instagramLinkButton.centerYAnchor.constraint(equalTo: instagramImageView.centerYAnchor),
                                      getDiscountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                                      getDiscountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      getDiscountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                      getDiscountButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    @IBAction func btnActionBack(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "promoSelectionVC") as! PromoSelectionViewController
        vc.brand = business
        Analytics.logEvent("get_discount_pressed", parameters: [
            "business" : business?.name ?? "?"
            ])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnActionBak(_ sender: Any) {
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @IBAction func btnGoInsta(_ sender: Any) {
        guard let url = URL(string: "https://www.instagram.com/\(business!.instagram)") else {
            UIApplication.shared.open(URL(string: "https://www.instagram.com")!)
            return
        }
        UIApplication.shared.open(url)
    }
    
    
    func configureViews() {
        view.backgroundColor = .clear
        
        imageLogo.sd_setImage(with: URL(string: business?.logo ?? ""), completed: nil)
        lblTitle.text = business?.name
        priceLabel.text = business?.pricePoint
        lblClose.text = "Closes at \(business!.closingTime)"
        lblTags.text = business!.keywords
        lbldes.text = business!.description
//        closeTimeLabel.text = "Closes at \(business!.closingTime)"
        imgInsta.image = UIImage(named: K.ImageNames.instaGlyph)?.withRenderingMode(.alwaysTemplate)
        btnDiscount.layer.cornerRadius = 25
        btnInsta.setTitle("See \(business!.name) on Instagram", for: .normal)
       // let image = UIImage(named: "leftArrowWhite")?.withRenderingMode(.alwaysTemplate)
       // btnMainBack.setImage(image, for:.normal)
       // btnMainBack.tintColor = UIColor.gray
    }
}
extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
