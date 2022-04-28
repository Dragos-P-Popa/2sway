//
//  FurtherInfoCell.swift
//  progressBar2
//
//  Created by user201027 on 8/9/21.
//

import UIKit

class FurtherInfoCell: UITableViewCell {
    
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    var isOpened: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Haven't been able to use this method yet
    func configure() {
        if isOpened {
            arrowView.image = UIImage(named: K.ImageNames.upArrowWhite)
        } else {
            arrowView.image = UIImage(named: K.ImageNames.downArrowWhite)
        }
    }
    
    func prepareForLight() {
        cellBackground.backgroundColor = UIColor(named: K.Colors.white)
        cellLabel.textColor = UIColor(named: K.Colors.black)
        arrowView.image = UIImage(named: K.ImageNames.downArrowBlack)
    }
    
    func prepareForDark() {
        cellBackground.backgroundColor = UIColor(named: K.Colors.white)
        cellLabel.textColor = UIColor(named:K.Colors.white)
        arrowView.image = UIImage(named: K.ImageNames.downArrowWhite)
    }
}
