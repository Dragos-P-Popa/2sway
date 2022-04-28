//
//  BundlesViewController.swift
//  progressBar2
//
//  Created by user201027 on 8/7/21.
//

import UIKit

class PromoSelectionViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var promoSelectionTableView: UITableView!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(gray: 0, alpha: 1),
                           CGColor(gray: 0, alpha: 0.3),
                           CGColor(gray: 0, alpha: 0)]
        gradient.locations = [0, 0.4, 1]
        return gradient
    }()
    
    let promoBrain = PromoBrain()
    
    // Brand to which the selected promo belongs
    var brand: Business? = nil
    
    // Once a promo is selected
    var selectedPromo: Promos? = nil
    
    var promos: [Promos] = []
    
    // needed for reference when leaving this view controller
    var initialInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we will need a reference to the initial delegate so that when we push or pop..
        // ..this view controller we can appropriately assign back the original delegate
        initialInteractivePopGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
        
        promos = brand!.promos
        brandImage.sd_setImage(with: URL(string: brand!.logo), completed: nil)
        promoSelectionTableView.dataSource = self
        promoSelectionTableView.delegate = self
        promoSelectionTableView.register(UINib(nibName: K.Cells.PromoCell, bundle: nil), forCellReuseIdentifier: K.Cells.PromoCell)
        //promoSelectionTableView.register(UINib(nibName: K.Cells.BrandDescCell, bundle: nil), forCellReuseIdentifier: K.Cells.BrandDescCell)
        promoSelectionTableView.register(UINib(nibName: K.Cells.FurtherInfoCell, bundle: nil), forCellReuseIdentifier: K.Cells.FurtherInfoCell)
        promoSelectionTableView.register(UINib(nibName: K.Cells.FurtherInfoDetailCell, bundle: nil), forCellReuseIdentifier: K.Cells.FurtherInfoDetailCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        brandImage.layer.insertSublayer(gradient, at: 0)
        
        // we must set the delegate to nil whether we are popping or pushing to..
        // ..this view controller, thus we set it in viewWillAppear()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        gradient.frame = brandImage.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // and every time we leave this view controller we must set the delegate back..
        // ..to what it was originally
        self.navigationController?.interactivePopGestureRecognizer?.delegate = initialInteractivePopGestureRecognizerDelegate
        
    }
    
    
    // Notify progress controller which promo has been selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SplashRulesViewController {
            vc.selectedPromo = self.selectedPromo
            vc.image = brandImage.image
            vc.isPromo = true
            vc.business = brand
        }
    //    let vc = self.storyboard?.instantiateViewController(withIdentifier:"RulesVC") as! RulesVC
      //  self.navigationController?.pushViewController(vc, animated:true)
    }
    
    // Back button functionality
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var furtherInfoCell = FurtherInfoCell()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // If expandable further info cell is pressed
        if indexPath.section == 1 && indexPath.row == 0 {
            furtherInfoCell.isOpened = !furtherInfoCell.isOpened
            tableView.reloadSections([indexPath.section], with: .none)
            if furtherInfoCell.isOpened {
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
}


extension PromoSelectionViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2    // Brand description, Promos, Further Info
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
        switch section {
//        case 0:     // Brand description
//            return 1
        case 1:     // Promos
            return promos.count
        default:
            return 0
        }

    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        switch indexPath.section {
//        case 0:     // Brand title and description
//
//            let brandDescCell = tableView.dequeueReusableCell(withIdentifier: K.Cells.BrandDescCell, for: indexPath) as! BrandDescCell
//            guard let brand = brand else {
//                fatalError("No brand registered with this ViewController")
//            }
//            brandDescCell.configure(with: brand)
//            return brandDescCell

        case 1:     // Promo cells

            let promoCell = tableView.dequeueReusableCell(withIdentifier: "PromoCell", for: indexPath)
                as! PromoCell

            promoCell.configure(with: promos[indexPath.row])
            promoCell.delegate = self
            return promoCell

        default:
            return UITableViewCell()
        }

    }
}

extension PromoSelectionViewController: PromoCellDelegate {
    func promoPressed(promo: Promos) {

        self.selectedPromo = promo
        performSegue(withIdentifier: K.Segues.toSelectedPromo, sender: self)
    }
}


