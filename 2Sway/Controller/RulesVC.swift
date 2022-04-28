//
//  RulesVC.swift
//  2Sway
//
//  Created by Techcronus on 21/04/22.
//

import UIKit
import CoreAudio

class RulesVC: UIViewController {
    
    //MARK: deClartion
    let skipButton: UIButton = {
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
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    var CurentPage = Int()
    var aryImage = [String]()
    var isIntro = Bool()
    
    
    var selectedPromo: Promos? = nil
    var image: UIImage?
    var business: Business?
    var isPromo = Bool()
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionRules: UICollectionView!
    
    //MARK: ViewController_LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        if isIntro == true {
            backButton.isHidden = true
            aryImage = ["introSplash1","introSplash2"]
        } else {
            backButton.isHidden = false
            aryImage = ["rulesSplash1","rulesSplash2","rulesSplash3","rulesSplash4"]
        }
        skipButton.center = CGPoint(x: view.frame.midX, y: view.frame.height - 90)
        view.addSubview(skipButton)
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: 50, height: 50)
        view.addSubview(backButton)
        let pcWidth: CGFloat = view.frame.width/2
        let pcHeight: CGFloat = 30
        pageControl.frame = CGRect(x: view.frame.width/2 - pcWidth/2, y: view.frame.height - 20 - pcHeight, width: pcWidth, height: pcHeight)
        pageControl.numberOfPages = aryImage.count
        pageControl.backgroundStyle = .prominent
        view.addSubview(pageControl)
    }
    override func viewDidLayoutSubviews() {
       
    }

    //MARK: CustomMethod
    @objc func skipPressed() {
        if isIntro == true {
            guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                return
            }
            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.navigationBar.isHidden = true
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            self.dismiss(animated:true, completion:nil)
        }
    }
    @objc func backButtonPressed() {
        self.dismiss(animated:true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        for cell in self.collectionRules.visibleCells {
//            let indexPath = self.collectionRules.indexPath(for: cell)
//            pageControl.currentPage = indexPath?.row ?? 0
//        }
        pageControl.currentPage = self.CurentPage
    }
}
//MARK: Extension_CollectionView
extension RulesVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for:indexPath) as! CollectionViewCell
        cell.imgSplash.image = UIImage(named:aryImage[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.CurentPage = indexPath.row
       // pageControl.currentPage = indexPath.row
    }
}
