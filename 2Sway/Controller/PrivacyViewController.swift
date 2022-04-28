//
//  PrivacyViewController.swift
//  progressBar2
//
//  Created by user201027 on 9/2/21.
//

import UIKit

class PrivacyViewController: UIViewController {
    
    private let topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
        return view
    }()
    
    private let textBox: UITextView = {
        let textBox = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        textBox.font = UIFont(name: K.font, size: 12)
        textBox.textColor = .black
        textBox.backgroundColor = .clear
        return textBox
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: K.ImageNames.downArrowBlack), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.font = UIFont(name: "JostRoman-Medium", size: 20)
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "Privacy Policy"
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Delete account", attributes: [.underlineStyle: 1, .font: UIFont(name: K.font, size: 12)!, .foregroundColor: UIColor.black]), for: .normal)
        button.backgroundColor = .clear
        button.isHidden = true
        return button
    }()
    
    func unhideDelete() {
        deleteButton.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        textBox.isUserInteractionEnabled = false
    }
    override func viewDidLayoutSubviews() {
        
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 86)
        mainView.frame = CGRect(x: 0, y: 96, width: view.frame.width, height: view.frame.height - 120)
        view.addSubview(topView)
        view.addSubview(mainView)
        
        backButton.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
        backButton.center.y = topView.frame.midY
        topView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        textBox.frame = CGRect(x: 16, y: 0, width: mainView.frame.width - 32, height: mainView.frame.height - 40)
        mainView.addSubview(textBox)
        
        titleLabel.frame = CGRect(x: 70, y: 0, width: 200, height: 50)
        titleLabel.center.y = topView.center.y
        topView.addSubview(titleLabel)
        
        deleteButton.frame = CGRect(x: 0, y: mainView.frame.height - 30, width: 150, height: 20)
        deleteButton.center.x = view.center.x
        mainView.addSubview(deleteButton)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteAccount() {
        performSegue(withIdentifier: K.Segues.toDeletePopUp, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.Colors.offWhite)
        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
        textBox.text =
            """
        2SWAY LTD incorporated and registered in GBP 2 and whose head office is located at 212 Copse Hill, London, England, SW20 0SP ( “we” or “2Sway”) provide the 2Sway mobile app to users (“you”)
        While providing our services, we recognize the importance of your privacy and carry out our activities in line with the applicable data protection regulation including the EU General Data Protection Regulation (“GDPR”) and other related laws.
        This Privacy Policy aims to specify how we collect, use and disclose your personal data to provide you with the best level of our service.
        Personal Data We Collect
        We collect and process your personal data such as:
        identity information including your full name and Instagram user ID
        contact information including your e-mail address,
        behavioural information including your usage activity
        Collection Method of Your Personal Data
        We collect your personal data in a number of ways, including:
        directly from you via e-mail and direct message on Instagram,
        from publicly available sources of information,
        from our own records of how you use 2Sway’s services.
        Use of Your Personal Data
        We collect, hold, use and disclose your personal data for the purposes including to:
        fulfil the functionality of the 2Sway mobile app,
        review your requests, suggestions and complaints regarding our service,
        fulfil contractual obligations to you and anyone involved in the process,
        monitor metrics such as total number of visitors, traffic and promotion patterns,
        identify and resolve errors, problems or bugs in our products and services,
        meet legal and regulatory requirements including compliance with applicable law, respond to requests from public and government authorities, including authorities outside your country of residence and to meet national security or law enforcement requirements.
        We collect and process your personal data on the following bases under the GDPR:
        to comply with our contractual obligation (for example, providing you with our service),
        to comply with our legal obligations,
        because of our company’s legitimate interests which include the provision of our mobile application and/or relevant services, provided always that our legitimate interests are not outweighed by any prejudice or harm your rights and freedoms,
        to establish, exercise or defend our legal claims before the courts, arbitrations, authorized data protection authorities or similar legal proceedings,
        because you have explicitly given us your consent to process your personal data in that manner.
        Disclosure of Your Personal Data
        We disclose your personal data
        with our employees, company directors, shareholders, representatives, suppliers, service providers, business partners and solution partners for the purposes specified in Section 3,
        with government and regulatory authorities and other organizations to meet legal and regulatory requirements, or to protect or defend our rights or property in accordance with applicable laws.
        For the compliance with the GDPR, we ensure that our suppliers and business or solution partners whether they are located outside the EEA or not, takes appropriate technical and organizational security measures in accordance with applicable data protection laws and use it solely for the purposes specified by us.
        Your Rights
        If you are from the European Economic Area or in certain countries, you are also entitled (with some exceptions and restrictions) to:
        Access: You have the right to request information about how we process your personal data and to obtain a copy of that personal data.
        Rectification: You have the right to request the rectification of inaccurate personal data about you and for any incomplete personal information about you to be completed.
        Objection: You have the right to object to the processing of your personal information, which is based on our legitimate interests (as described above).
        Deletion: You can delete your account by using the corresponding functionality directly on the service.
        Automated decision-making: You have the right to object a decision made about you that is based solely on automated processing if that decision produces legal or similarly significant effects concerning you.
        Restriction: You have the right to ask us to restrict our processing of your personal data, so that we no longer process that personal data until the restriction is lifted.
        Portability: You have the right to receive your personal data, which you have provided to us, in a structured, commonly used and machine-readable format and to have that personal data transmitted to another organization in certain circumstances.
        Complaint: You have a right to lodge a complaint with the authorized data protection authority if you have concerns about how we process your personal data. The data protection authority you can lodge a complaint with notably may be that of your habitual residence, where you work or where we are established.
        You may, at any time, exercise any of the above rights, by contacting us via hello@2sway.co.uk together with a proof of your identity, i.e. a copy of your ID card, or passport, or any other valid identifying document.
        In some cases, we may not be able to give you access to your personal data that we hold, if making such a disclosure would breach our legal obligations to our other customers or if prevented by any applicable law or regulation.
        Right to withdraw consent
        If you have provided your consent to the collection, processing and transfer of your personal data, you have the right to fully or partly withdraw your consent. To withdraw your consent please contact us via hello@2sway.co.uk or delete your account within the app.
        Once we have received notification that you have withdrawn your consent, we will no longer process your information for the purpose(s) to which you originally consented unless there are compelling legitimate grounds for further processing which override your interests, rights and freedoms or for the establishment, exercise or defence of legal claims.
        Collection of Children’s Personal Data
        We attach great importance of protecting children’s privacy. Therefore, we make an effort to not collect personal data of any children under the age of 13. If you have any concerns about your child’s privacy with respect to our services, or if you believe that your child may have provided his/her personal data to us, please contact us via hello@2sway.co.uk. We ensure to delete such personal data from our records promptly.
        Security of Your Personal Data
        We take appropriate and reasonable technical and organizational measures to protect your personal data from loss, misuse, unauthorized access, disclosure, alteration, and destruction, taking into account the risks involved in the processing and the nature of the personal data. Such technical and organizational measures include:
        Using state of the art hosting systems for your data,
        Preparing and organizing corporate policies on access, information security, usage, retention and disposal.
         
        Retention of Your Personal Data
        We will only retain your personal data for as long as necessary to fulfil our collection purposes, including for the purposes of satisfying any legal, accounting, or reporting requirements, and where required for our company to provide services, until the end of the relevant retention period.
        To determine the appropriate retention period for personal data, we consider the amount, nature, and sensitivity of the personal data, the potential risk of harm from unauthorized use or disclosure of your personal data, the purposes for which we process your personal data and whether we can achieve those purposes through other means, and the applicable legal requirements. Upon expiry of the applicable retention period, we will securely delete, destroy or anonymize your personal data in accordance with applicable laws and regulations at the earliest time that is feasible for us to do so.
        Links to Third Party Sites
        Our mobile application includes links to other websites or apps whose privacy practices may differ from those of our companies. If you submit personal information to any of those sites, your information is governed by their Privacy Policies. We encourage you to carefully read the Privacy Policy of any website or app you visit.
        Changes to our Privacy Policy
        We reserve the right to update and change this Policy at any time in order to reflect any changes to the way in which we process your personal data or changing legal requirements. Any changes we may make to our Policy in the future will be posted on this page and, where appropriate, notified to you by e-mail or push notification. Please check back frequently to see any updates or changes to our Policy.
        Contact us
        If you have any questions or concerns about our privacy practices or would like to exercise any of the rights mentioned in this Privacy Policy, please contact us via hello@2sway.co.uk. You may also contact us by postal at our address stated above.
        """
    }
    
}
