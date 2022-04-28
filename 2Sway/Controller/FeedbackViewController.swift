//
//  FeedbackViewController.swift
//  2Sway
//
//  Created by Abhishek Dubey on 17/01/22.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: K.ImageNames.downArrowWhite)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Help us improve"
        label.font = UIFont(name: "HelveticaNeue", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "We’re constantly making changes to improve the 2Sway user experience, and we know we're far from perfect at the moment. We greatly appreciate you letting us know in this form about any bugs you've found. We also love hearing your feature requests, so send them in and we'll see what we can do!"
        label.font = UIFont(name: "Jost-VariableFont_wght", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .label
        textView.textColor = .systemBackground
        textView.layer.cornerRadius = 20
        textView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.font = UIFont(name: "Jost-VariableFont_wght", size: 16)
        return textView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 24.5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraints()
        configureTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submitButtonPressed() {
        let mainString  = textView.text ?? ""
        let cleanString = mainString.trimmingCharacters(in: .whitespaces)
        if cleanString == "" {
            GlobalAlert.showAlertMessage(vc: self, titleStr:K.appName, messageStr:"Please enter feedback ")
        } else {
           
            DatabaseManager.shared.submitFeedback(feedback: Feedback(username: ActiveUser.activeUser.email!, description:cleanString, timeStamp: Date())) { submitted in
                if submitted {
                    let alert = UIAlertController(title: "Submitted", message: "Thanks for the feedback, we really appreciate it!", preferredStyle: UIAlertController.Style.alert)
                    self.textView.text = ""
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func addViews() {
        view.backgroundColor = .systemBackground
        let views = [backButton, descriptionLabel, titleLabel, textView, submitButton]
        views.forEach({ view.addSubview($0) })
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([ backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                                      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                      backButton.widthAnchor.constraint(equalToConstant: 30),
                                      backButton.heightAnchor.constraint(equalToConstant: 30),
                                      titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
                                      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                      descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
                                      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
                                      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34),
                                      textView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 37),
                                      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
                                      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
                                      textView.heightAnchor.constraint(equalToConstant: 352),
                                      submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
                                      submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
                                      submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58),
                                      submitButton.heightAnchor.constraint(equalToConstant: 49)
                                    ])
    }
}
