//
//  FurtherInfoDetailCell.swift
//  progressBar2
//
//  Created by user201027 on 8/9/21.
//

import UIKit

class FurtherInfoDetailCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var desc0: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var subtitle3: UILabel!
    @IBOutlet weak var desc3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareForLight() {
        cellBackground.backgroundColor = UIColor(named: K.Colors.white)
        desc0.textColor = UIColor(named: K.Colors.black)
        desc1.textColor = UIColor(named: K.Colors.black)
        desc2.textColor = UIColor(named: K.Colors.black)
        desc3.textColor = UIColor(named: K.Colors.black)
        subtitle1.textColor = UIColor(named: K.Colors.black)
        subtitle2.textColor = UIColor(named: K.Colors.black)
        subtitle3.textColor = UIColor(named: K.Colors.black)
    }
    
    
}
