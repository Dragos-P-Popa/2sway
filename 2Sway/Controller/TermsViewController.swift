//
//  TermsViewController.swift
//  progressBar2
//
//  Created by user201027 on 9/2/21.
//

import UIKit

class TermsViewController: UIViewController {
    
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
        label.text = "Terms of Use"
        return label
    }()
    
    override func viewDidLayoutSubviews() {
        
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 86)
        mainView.frame = CGRect(x: 0, y: 96, width: view.frame.width, height: view.frame.height - 96)
        view.addSubview(topView)
        view.addSubview(mainView)

        backButton.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
        backButton.center.y = topView.frame.midY
        topView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        textBox.frame = CGRect(x: 16, y: 0, width: mainView.frame.width - 32, height: mainView.frame.height - 20)
        mainView.addSubview(textBox)
        
        titleLabel.frame = CGRect(x: 70, y: 0, width: 200, height: 50)
        titleLabel.center.y = topView.center.y
        topView.addSubview(titleLabel)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        textBox.isUserInteractionEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.Colors.offWhite)
        
        textBox.text = """
            1. Recitals
            The services offered by 2SWAY LTD (“2Sway”) allow users to have the opportunity to get discounts at our partnered venues (“Partners”) in proportion to the number of views on their Instagram stories.
            Access and use of the services offered by 2Sway are subject to these Terms and Conditions and imply the users' express, prior full acceptance thereof and of the privacy policy of 2Sway.
            The following words have the following meanings in this Agreement: 2Sway: 2SWAY LTD incorporated and registered in England and under number 13579396 and whose head office is located at 212 Copse Hill, London, England, SW20 0SP. Application: The application offered by 2SWAY LTD, which is available on Apple Store: The services provided by 2SWAY LTD via the Application, allowing Users to obtain discounts at venues in relation to their story views. User (or you): Any legal entity which has set up an account and which accesses and uses the Services.
            Last Update: 23 August 2021
            2. Acceptance of the Terms
            2.1. By accessing and using the 2Sway application, you accept to be legally bound by the Terms and Conditions. If you disagree with any provision of these Terms and Conditions, please do not use our application. Before you continue, 2Sway recommends you save a local copy of these Terms and Conditions for your records.
            2.2. You must be 16 years or older to use this Application. 2Sway is not responsible for any misrepresentation of age. By using this Application, you certify and guarantee that all data provided by you is correct and accurate.
            2.3. By using the Application, you accept to comply with local, state, national and international laws, and you assure that you are legally able to use our Services.
            3. Language of the Termssign
            3.1. This Terms and Conditions document (“Terms”) is provided in English. 2Sway may provide you with a translation of these Terms. You agree that the translated version is provided only for your convenience, and the English version will govern your relationship with 2Sway.
            3.2. If there is any contradiction between the original Terms (the English version of the Terms) and the translation, the original Terms shall take precedence over the translation.
            4. Content and Products
            4.1. 2Sway is an application for Instagram Account holders at universities in the United Kingdom and allows users to gain discounts at 2Sway’s partnered venues according to the terms of their deal.
            4.2. You are able to get discounts at our partnered venues for posting on your Instagram story as long as you follow The Rules as detailed in the application.
            5. Main Terms
            5.1. You are solely responsible for your account and any activity that occurs through your account. 2Sway prohibits the creation of an account for anyone other than yourself. You also represent that all information you provide or provided to 2Sway upon registration and at all other times will be true.
            5.2. You agree that you will not solicit, collect or use the login credentials of other 2Sway users.
            5.3. In the event that you provide false, inaccurate, erroneous, outdated, incomplete, misleading or deceptive information, 2Sway may immediately, without notice or compensation, suspend or terminate your account and temporarily or permanently deny your access to the Application and/or to the Services. Moreover, 2Sway may not, under any circumstances, be held liable in case of non-performance and/or partial performance of the subscription in relation to the provision of information of that nature.
            5.4. You must not access 2Sway private API by means other than those permitted. You must not interfere or disrupt the Service or servers or networks connected to the Service, including by transmitting any worms, viruses, spyware, malware or any other code of a destructive or disruptive nature.
            5.5. You must not create accounts with the Service through unauthorised means, including but not limited to, by using an automated device, script, bot, spider, crawler or scraper.
            5.6. You can delete your account within the app, by direct message to 2Sway’s Instagram account, or by emailing hello@2sway.co.uk. If 2Sway terminate your access to the Service or you delete your account, your discounts, information, and other data will no longer be accessible through your account.
            5.7. There may be links from the Service or from communications you receive from the Service to third-party websites or features. There may also be links to third-party websites or features in images or comments within the Service. The Service may also include third-party content that we do not control, maintain or endorse. Functionality on the Service may also permit interactions between the Service and a third-party website or feature, including applications that connect the Service or your profile on the Service with a third-party website or feature. 2Sway does not control any of these third-party web services or any of their content. You expressly acknowledge and agree that 2Sway is in no way responsible or liable for any such third-party services or features.
            5.8. Your correspondence and business dealings with third parties found through the service are solely between you and the third party. You may choose, at your sole and absolute discretion and risk, to use applications that connect the Service or your profile on the Service with a third-party service (each, an "Application"), and such Application may interact with, connect to or gather and/or pull information from and to your Service profile.
            5.9. The Terms are regularly updated. Users are therefore advised to read these Terms and Conditions every time they visit the Website and/or the Application. 2Sway reserves the right to refuse access to the Service to anyone, for any reason, at any time, and reserves the right to force the forfeiture of any User, for any reason. 2Sway may, but have no obligation to, remove, edit, block, and/or monitor Content or accounts containing content that determine in our sole discretion violates Terms.
            5.10 You understand that you will not be credited for posts on your Instagram Story that do not follow The Rules within the app, or violate Instagram’s guidelines.
            5.11 Discounts must be used before they expire, two weeks after they are redeemed.
            5.12 You understand that discounts provided to you, the User, are not earned by you or provide as payment. They are simply gifts that may or may not be provided. 2Sway reserves the right to remove any discounts that have been provided at any time and will not be liable for any loss to the User.
            6. No Warranties
            6.1. You understand and agree that the Services are provided ‘‘as is’’. The products or services available in our Application may be mispriced, described inaccurately or unavailable, and we may experience delays in updating information in the Application and in our advertising on other websites.
            6.2. In particular, 2Sway does not guarantee that the Services will operate without interruption, securely or without malfunction; that the quality of any Service, including the results obtained via the Services, will meet User’s expectations; that the results of the data collected by the features are complete, exhaustive true, accurate or reliable.
            6.3. No information or advice given by 2Sway to you in relation to the use of the Services shall be regarded as the provision of a guarantee.
            7. Privacy and Security
            2Sway is committed to protecting your privacy. Please see our 2Sway Privacy Policy within the app or via www.2sway.co.uk to learn how we collect, use and disclose your personal data.
            7.1. 2Sway implements appropriate technical and organisational measures to protect the Application within the industry standards.
            7.3. We do not collect any special categories of personal data or sensitive data, such as any information on the User’s health, religious beliefs, political opinions, sexual preferences or orientation.
            8. Intellectual Property
            8.1. Other than your content under this Terms, 2Sway and/or its licensors own all the intellectual property rights and materials contained in this Application. You are granted a limited license only for purposes of viewing the material contained on this Application.
            8.2. “2Sway’’ name and logo are trademarks of 2Sway, and may not be copied, imitated or used, in whole or in part, without the prior written permission of 2Sway. In addition, all page headers, custom graphics, button icons and scripts may not be copied, imitated or used, in whole or in part, without prior written permission from 2Sway.
            8.3. The Service contains content owned or licensed by 2Sway and its Partners. Contents of 2Sway and its Partners are protected by copyright, trademark, patent, trade secret and other laws, and, as between you and 2Sway. 2Sway owns and retains all rights in such content and the Service. You will not remove, alter or conceal any copyright, trademark, service mark, or other proprietary rights notices incorporated in or accompanying the contents of 2Sway or its Partners, and you will not reproduce, modify, adapt, prepare derivative works based on, perform, display, publish, distribute, transmit, broadcast, sell, license or otherwise exploit the content
            10. Restrictions
            You are specifically restricted from all of the following:
            copying, transmitting, distributing, reverse engineering, modifying, publishing, or participating in the transfer or sale of, creating derivative works from, or in any other way exploiting any of Application material;
            selling, sublicensing and/or otherwise commercialising any Application material;
            publicly performing and/or showing any Application material;
            using this Application in any way that is or may be damaging to this Application;
            participating or engaging in, or causing others to participate or engage in, the intentional abuse or misuse of Application;
            using this Application in any way that impacts user access to this Application;
            using this Application contrary to applicable laws and regulations, or in any way may cause harm to the Application, or to any person or business entity;
            engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to this Application;
            Certain areas of this Application are restricted from being accessed by you, and 2Sway may further restrict access by you to any areas of this Application, at any time, in absolute discretion. Any password you may have for this Platform is confidential, and you must maintain confidentiality as well.
            11. Limitation of Liability
            In no event, 2Sway and any of its officers, directors and employees shall be held liable for anything arising out of or in any way connected with your use of this Application whether such liability is under contract. 2Sway, including its officers, directors and employees, shall not be held liable for any indirect, consequential or special liability arising out of or in any way related to your use of this Application.
            12. Indemnification
            You hereby indemnify to the fullest extent 2Sway from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of this Terms and Conditions.
            13. Severability
            If any provision of these Terms and Conditions is found to be invalid under any applicable law, such provisions shall be deleted without affecting the remaining provisions herein.
            14. Changes of Agreement
            2Sway may amend the agreement at any time with notice that we deem to be reasonable under the circumstances by posting the revised version on our platform or communicating it to you through the Services. Such a revised version will be effective as of the time it is posted but will not apply retroactively.
            15. Force Majeure
            Neither 2Sway nor the User will be liable for delays in processing or other non-performance caused by such events as fires, telecommunications, utility, or power failures, equipment failures, labour strife, riots, war, non-performance of our vendors or suppliers, acts of God, or other causes over which the respective party has no reasonable control; provided that the party has procedures reasonably suited to avoid the effects of such acts.
            16. Governing Law and Jurisdiction
            This Agreement will be governed by and interpreted in accordance with English and Welsh Law, without giving effect to any principles of conflicts of law. Disputes with 2Sway and arising from the use of 2Sway shall resolute exclusively in the courts of England and Wales.
            You agree that any claim you may have arising out of or related to your relationship with 2Sway must be filed within three months after such claim arose; otherwise, your claim is permanently barred.
            17. Territorial Restrictions
            2Sway reserves the right to limit the availability of the Service or any portion of the Service, to any person, geographic area, or jurisdiction, at any time and in our sole discretion, and to limit the quantities of any content, program, product, service or other feature that 2Sway provides.
            18. Contact Us
            If you have any questions or requests, please contact us at hello@2sway.co.uk

            """
    }

}
