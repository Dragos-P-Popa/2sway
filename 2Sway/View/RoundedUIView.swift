//
//  RoundedUIView.swift
//  progressBar2
//
//  Created by user201027 on 8/9/21.
//

import UIKit

@IBDesignable public class RoundedUIView: UIView {

        override public func layoutSubviews() {
            super.layoutSubviews()

            self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2;
            self.layer.masksToBounds = true
        }
    }
