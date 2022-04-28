//
//  IntroViewController.swift
//  progressBar2
//
//  Created by user201027 on 9/2/21.
//

import UIKit

class IntroViewController: UIViewController, UIScrollViewDelegate {
    
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
        var pageCount: Int = 0
        
        
        view.addSubview(scrollView)
        
        for image in 1...2 {
            let imageToDisplay = UIImage(named: "introSplash\(image)")
            let imageView = UIImageView(image: imageToDisplay)
            
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
        scrollView.addSubview((finalView))
        pageCount += 1
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pageCount), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        // Adding Page Control
        let pcWidth: CGFloat = view.frame.width/2
        let pcHeight: CGFloat = 30
        pageControl.frame = CGRect(x: view.frame.width/2 - pcWidth/2, y: view.frame.height - 20 - pcHeight, width: pcWidth, height: pcHeight)
        pageControl.numberOfPages = pageCount
        pageControl.backgroundStyle = .prominent
        view.addSubview(pageControl)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            performSegue(withIdentifier: K.Segues.introToHome, sender: self)
        }
    }
    
}
