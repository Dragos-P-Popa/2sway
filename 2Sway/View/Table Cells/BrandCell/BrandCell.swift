//
//  BrandCell.swift
//  progressBar2
//
//  Created by Joe Feest on 26/07/2021.
//

import UIKit
import SDWebImage

protocol BrandCellDelegate: HomeViewController {
    func brandPressed(brand: Business)
}

class BrandCell: UITableViewCell {
    
    weak var delegate: BrandCellDelegate?
    
    private var brand: Business? = nil
       
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var brandButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.layer.cornerRadius = 10
        
    }
    
    @IBAction func brandPressed(_ sender: UIButton) {
        delegate?.brandPressed(brand: brand!)
    }
    
    func configure(with brand: Business) {
        self.brand = brand
        brandImage.sd_setImage(with: URL(string: brand.logo), completed: nil)
        titleLabel.text = brand.name
        descLabel.text = "Max discount: \(Int(brand.highestDiscount))%"
    }
    
}
