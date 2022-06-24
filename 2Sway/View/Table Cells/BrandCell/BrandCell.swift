//
//  BrandCell.swift
//  progressBar2
//
//  Created by Joe Feest on 26/07/2021.
//

import UIKit
import SDWebImage
import MapKit

protocol BrandCellDelegate: HomeViewController {
    func brandPressed(brand: Business)
}

class BrandCell: UITableViewCell, CLLocationManagerDelegate {
    
    weak var delegate: BrandCellDelegate?
    
    private var brand: Business? = nil
    
    var locations: [Locations] = []
       
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.layer.cornerRadius = 10
        
    }
    
    @IBAction func brandPressed(_ sender: UIButton) {
        delegate?.brandPressed(brand: brand!)
    }
    
    func configure(with brand: Business, location: CLLocationCoordinate2D) {
        self.brand = brand
        brandImage.sd_setImage(with: URL(string: brand.logo), completed: nil)
        titleLabel.text = brand.name
        descLabel.text = "Max discount: \(Int(brand.highestDiscount))%"
        tagLabel.text = brand.keywords
        
        let locationManager = CLLocationManager()

        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.mapLabel.text = "\(brand.locations[0].address)"
                case .authorizedAlways, .authorizedWhenInUse:
                    locations = brand.locations
                    
                    let coordinate₀ = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    let coordinate₁ = CLLocation(latitude: locations[0].latitude, longitude: locations[0].longitude)

                    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                    
                    self.mapLabel.text = "\(String(format:"%.2f", distanceInMeters / 1609)) miles away"
                @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
}
