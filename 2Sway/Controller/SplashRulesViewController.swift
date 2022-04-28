//
//  SplashRulesViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 17/09/2021.
//

import UIKit

class SplashRulesViewController: UIViewController, UIScrollViewDelegate {
    
    var selectedPromo: Promos? = nil
    var image: UIImage?
    var business: Business?
    var isPromo = Bool()
    var pageCount: Int = 0

    private let skipButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.backgroundColor = .clear
        button.setAttributedTitle(NSAttributedString(string: "Skip", attributes: [.underlineStyle: 1, .font: UIFont(name: K.font, size: 16)!]), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
       // let mainImage = UIImage(named: K.ImageNames.leftArrowWhite), for: .normal)
        let mainImage = UIImage(named: "leftArrowWhite")?.withRenderingMode(.alwaysTemplate)
        button.setImage(mainImage, for:.normal)
        button.tintColor = UIColor.gray
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let pageWidth = view.frame.width
        let pageHeight = view.frame.height
        let aspectRatio: CGFloat = 9.0/16.0
        let height = pageHeight - 140
        let width = height * aspectRatio
        
        let xInset = (pageWidth - width) / 2
        // Adding scrollView
        scrollView.frame = CGRect(x: xInset, y: 70, width: width, height: height)
        view.addSubview(scrollView)
        
        for image in 1...4 {
            let imageToDisplay = UIImage(named: "rulesSplash\(image)")
            let imageView = UIImageView(image: imageToDisplay)
            print()
            let xCoord = scrollView.frame.width * CGFloat(image-1)
            scrollView.addSubview(imageView)
            
            let imageWidth = scrollView.frame.width
            let imageHeight = scrollView.frame.height
            
            imageView.frame = CGRect(x: xCoord, y: 0, width: imageWidth, height: imageHeight)
            pageCount += 1
        }
        
        // Add "invisble" page at the end to segue to HomeVC
        let finalView = UIView(frame: CGRect(x: scrollView.frame.width * CGFloat(pageCount), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
        finalView.backgroundColor = .clear
        
      //  scrollView.addSubview((finalView))
      //  pageCount += 1
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pageCount), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        // Adding Page Control
        let pcWidth: CGFloat = view.frame.width/2
        let pcHeight: CGFloat = 30
        pageControl.frame = CGRect(x: view.frame.width/2 - pcWidth/2, y: view.frame.height - 20 - pcHeight, width: pcWidth, height: pcHeight)
        print(pageCount)
        pageControl.numberOfPages = pageCount
        pageControl.backgroundStyle = .prominent
        view.addSubview(pageControl)
        pageControl.currentPage = -1
        // Adding skip button
        skipButton.center = CGPoint(x: view.frame.midX, y: view.frame.height - 90)
        view.addSubview(skipButton)
        
        // Adding back button
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: 50, height: 50)
        view.addSubview(backButton)
    }
    
    @objc func skipPressed() {
//        let rightPageX = CGFloat(pageCount-1) * scrollView.frame.width
//        scrollView.setContentOffset(CGPoint(x: rightPageX, y: 0), animated: true)
        if isPromo == true {
            performSegue(withIdentifier: K.Segues.toPromoView, sender: self)
        } else {
           let rightPageX = CGFloat(pageCount-1) * scrollView.frame.width
           scrollView.setContentOffset(CGPoint(x: rightPageX, y: 0), animated: true)
        }
    }
    
    @objc func backButtonPressed() {
        if backButton.image(for: .normal) == UIImage(named: K.ImageNames.downArrowWhite) {
            self.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let promo = self.selectedPromo else {
            fatalError("Selected promo is nil.")
        }
        if let vc = segue.destination as? PromoViewController {
            vc.selectedPromo = promo
            vc.image = image
            vc.business = business
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int((scrollView.contentOffset.x) / scrollView.frame.width)
//        if pageControl.currentPage == pageControl.numberOfPages - 1 {
//
//            if backButton.image(for: .normal) == UIImage(named: K.ImageNames.downArrowWhite) {
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                performSegue(withIdentifier: K.Segues.toPromoView, sender: self)
//            }
//        }
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        print(Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.width))))
//        self.pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.width)))
//    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
      //  print(Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.width))))
//        self.pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.width)))
        
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}


