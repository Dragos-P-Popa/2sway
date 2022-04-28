//
//  PromoCell.swift
//  progressBar2
//
//  Created by user201027 on 8/7/21.
//

import UIKit

protocol PromoCellDelegate: PromoSelectionViewController {
    func promoPressed(promo: Promos)
}

class PromoCell: UITableViewCell {
    @IBOutlet weak var promoName: UILabel!
    @IBOutlet weak var promoDesc: UILabel!
    @IBOutlet weak var lowViewsTitle: UILabel!
    @IBOutlet weak var lowViewsDesc: UILabel!
    @IBOutlet weak var midViewsTitle: UILabel!
    @IBOutlet weak var midViewsDesc: UILabel!
    @IBOutlet weak var highViewsTitle: UILabel!
    @IBOutlet weak var highViewsDesc: UILabel!
    
    weak var delegate: PromoCellDelegate?
    private var promo: Promos?
    
    // Extra text apart from raw data from Promo
    let viewsBlurb: String = "views"
    let descriptionBlurb: String = "% off"
        
    func configure(with promo: Promos) {
        self.promo = promo
        promoName.text = promo.name
        promoDesc.text = promo.description
        lowViewsTitle.text = "\(promo.lowestView) \(viewsBlurb)"
        lowViewsDesc.text = "\(promo.lowestDiscount)\(descriptionBlurb)"
        midViewsTitle.text = "\(promo.middleView) \(viewsBlurb)"
        midViewsDesc.text = "\(promo.middleDiscount)\(descriptionBlurb)"
        highViewsTitle.text = "\(promo.highestView) \(viewsBlurb)"
        highViewsDesc.text = "\(promo.highestDiscount)\(descriptionBlurb)"
    }
    
    @IBAction func promoPressed(_ sender: UIButton) {
        delegate?.promoPressed(promo: promo!)
    }
}
