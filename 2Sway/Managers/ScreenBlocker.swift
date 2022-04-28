//
//  ScreenBlocker.swift
//  progressBar2
//
//  Created by user201027 on 9/3/21.
//

import UIKit

class ScreenBlocker {
    
    private var warningWindow: UIWindow?
    
    private var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
    
    func startPreventingRecording() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    @objc private func didDetectRecording() {
        
        DispatchQueue.main.async {
            
            // Both of the below methods include actions for when screen recording is being turned off
            self.hideScreen()
            self.presentWarningWindow()
        }
        
    }
    
    private func hideScreen() {
        if UIScreen.main.isCaptured {
            window?.isHidden = true
        } else {
            window?.isHidden = false
        }
    }
    
    private func presentWarningWindow() {
        
        if UIScreen.main.isCaptured == false {
            warningWindow?.removeFromSuperview()
            warningWindow = nil
        } else {
            
            // Remove exsiting
            warningWindow?.removeFromSuperview()
            warningWindow = nil
            
            guard let window = window else { return }
            
            let frame = window.frame
            
            let labelOffsetX: CGFloat = 40
            let labelFrame = CGRect(x: labelOffsetX, y: 0, width: window.frame.width - 2*labelOffsetX, height: window.frame.height)
            
            // Warning label
            let label = UILabel(frame: labelFrame)
            label.numberOfLines = 0
            label.font = UIFont(name: K.font, size: 25)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "Screen recording is not allowed on this page"
            
            // Warning window
            var warningWindow = UIWindow(frame: frame)
            
            let windowScene = UIApplication.shared
                .connectedScenes
                .first {
                    $0.activationState == .foregroundActive
                }
            if let windowScene = windowScene as? UIWindowScene {
                warningWindow = UIWindow(windowScene: windowScene)
            }
            
            warningWindow.frame = frame
            warningWindow.backgroundColor = .black
            warningWindow.windowLevel = UIWindow.Level.statusBar + 1
            warningWindow.clipsToBounds = true
            warningWindow.isHidden = false
            warningWindow.addSubview(label)
            
            self.warningWindow = warningWindow
            
            UIView.animate(withDuration: 0.15) {
                label.alpha = 1.0
                label.transform = .identity
            }
            warningWindow.makeKeyAndVisible()
        }
    }
}
