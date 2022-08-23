//
//  Gradient.swift
//  2Sway
//
//  Created by Dragos Popa on 21/07/2022.
//

import UIKit

@IBDesignable
public class Gradient: UIView {
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.init(white: 0, alpha: 0).cgColor,
            UIColor.black.cgColor
        ]
        backgroundColor = UIColor.clear
    }
}
