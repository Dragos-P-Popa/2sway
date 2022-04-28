//
//  RulesViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 17/08/2021.
//

import UIKit

class RulesViewController: UIViewController {

    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsButton.layer.cornerRadius = termsButton.frame.height/5
        privacyButton.layer.cornerRadius = privacyButton.frame.height/5


    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termsButtonPressed(_ sender: UIButton) {
        GlobalShare.ShareUrl(urlPath:"https://www.2sway.co.uk/termsconditions")
        //performSegue(withIdentifier: K.Segues.toTerms, sender: self)
    }
    
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
        GlobalShare.ShareUrl(urlPath:"https://www.2sway.co.uk/privacypolicy")

        //performSegue(withIdentifier: K.Segues.toPrivacy, sender: self)
    }
}
