////
////  SelectedPromoCell.swift
////  progressBar2
////
////  Created by user201027 on 8/9/21.
////
//
//import UIKit
//
//protocol SelectedPromoCellDelegate: PromoViewController {
//    func claimNowPressed(promo: Promo, viewCount: Int)
//    func refreshRowHeight()
//}
//
//
//class SelectedPromoCell: UITableViewCell, ProgressBarDelegate2 {
//
//    @IBOutlet weak var promoTitle: UILabel!
//    @IBOutlet weak var ivePostedBackground: RoundedUIView!
//    @IBOutlet weak var statusText: UILabel!
//    @IBOutlet weak var informationText: UILabel!
//    @IBOutlet weak var ivePostedButton: UIButton!
//    @IBOutlet weak var claimNowButton: UIButton!
//    @IBOutlet weak var verifyingLabel: UILabel!
//
//    private var selectedPromo: Promo?
//    let progressBar = ProgressBar()
//    weak var delegate: SelectedPromoCellDelegate?
//    private var timeVerified: Date?
//    private var isClaimable: Bool = false
//
//    private weak var displayLink: CADisplayLink?
//    private var isVerifying: Bool = false {
//        didSet {
//            if isVerifying {
//                startDisplayLink()
//            } else {
//                stopDisplayLink()
//            }
//        }
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(animateProgressShow), name: Notification.Name("isVerified"), object: nil)
//
//        let height = claimNowButton.frame.height
//        claimNowButton.layer.cornerRadius = height/2
//        claimNowButton.alpha = 0.0
//        progressBar.delegate = self
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // Set spacing between cells
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
//    }
//
//    func configurePrePress(with promo: Promo) {
//        self.selectedPromo = promo
//        promoTitle.text = promo.promoTitle
//        statusText.text = "Maximum discount: \(Int(promo.highDiscountPerc))% off"
//    }
//
//    @IBAction func ivePostedPressed(_ sender: UIButton) {
//        configureAfterPress()
//
//        delegate?.ivePostedPressed()  //changes the 4 pointer text boxes to display new rules
//    }
//
//    func configureAfterPress() {
//        isVerifying = true
//
//        informationText.text = """
//            We are just verifying that everything checks out with your post. This won’t take longer than 15 minutes. Don’t worry, you’ll still be rewarded for the views you are getting in the meantime!
//            """
//        progressBar.lowViews = selectedPromo!.lowViews
//        progressBar.midViews = selectedPromo!.midViews
//        progressBar.highViews = selectedPromo!.highViews
//        animateVerifyShow()
//
//        timeVerified = Date().addingTimeInterval(TimeInterval(K.timeToVerify))
//        createTimer()
//    }
//
//    func createTimer() {
//
//        let _ = Timer.scheduledTimer(withTimeInterval: K.refreshCheckInterval, repeats: true) { timer in
//            // Check whether enough time has elapsed
//            if Date() > self.timeVerified! {
//                self.isVerifying = false
//                NotificationCenter.default.post(name: Notification.Name("isVerified"), object: nil)    // Notification is received by VC and progress bar is shown
//                timer.invalidate()
//            }
//        }
//    }
//
//    // Fade in Verifiying view
//    func animateVerifyShow() {
//
//        self.verifyingLabel.alpha = 0.0
//        self.ivePostedButton.isHidden = true
//
//        UIView.animate(withDuration: K.animationTime, animations: {
//
//            self.verifyingLabel.alpha = 1.0
//            self.ivePostedBackground.backgroundColor = UIColor(named: K.Colors.lightGrey)
//        })
//    }
//
//    // Refresh animation at same rate as display refresh (60Hz or whatever)
//    private func startDisplayLink() {
//        stopDisplayLink() // stop previous display link if one happens to be running
//
//        let link = CADisplayLink(target: self, selector: #selector(loadingAnimation))
//        link.add(to: .main, forMode: .common)
//        displayLink = link
//    }
//
//    private func stopDisplayLink() {
//        displayLink?.invalidate()
//    }
//
//    var alphaValue: CGFloat = 1.0
//    var invert: Bool = false
//    @objc func loadingAnimation() {
//
//        invert ? (alphaValue -= 0.005) : (alphaValue += 0.005) // If invert is true then minus 1, otherwise add 1
//        ivePostedBackground.alpha = alphaValue
//
//        if alphaValue > K.LoadingAnimation.maxAlpha || alphaValue < K.LoadingAnimation.minAlpha {
//            invert = !invert
//        }
//    }
//
//    // Fade in progress bar and Redeem button
//    @objc func animateProgressShow() {
//
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("isVerified"), object: nil)
//
//        UIView.animate(withDuration: K.animationTime, animations: {
//            guard let delegate = self.delegate else { return }
//
//                self.ivePostedBackground.addSubview(self.progressBar)
//                self.progressBar.draw(self.ivePostedBackground.bounds)
//
//                self.claimNowButton.isHidden = false
//                delegate.refreshRowHeight()
//
//                self.claimNowButton.alpha = K.unpressableAlpha
//                self.ivePostedBackground.backgroundColor = .clear
//                self.ivePostedBackground.alpha = 1.0
//
//                self.informationText.text = """
//                    Redeem whenever you want to stop us from monitoring your story. Remember that once you redeem, you’ll have to post again to get more discounts!
//                    """
//        })
//    }
//
//    func makeClaimable() {
//        isClaimable = true
//        claimNowButton.alpha = 1.0
//    }
//
//    @IBAction func increaseViews(_ sender: UIButton) {
//        progressBar.viewCount += 20
//    }
//
//    @IBAction func claimNowPressed(_ sender: UIButton) {
//        if isClaimable {
//            delegate?.claimNowPressed(promo: selectedPromo!, viewCount: progressBar.viewCount)
//            progressBar.viewCount = 0
//        }
//    }
//}
