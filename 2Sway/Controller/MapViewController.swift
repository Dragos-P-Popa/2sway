//
//  MapViewController.swift
//  2Sway
//
//  Created by Dragos Popa on 06/07/2022.
//

import Foundation
import UIKit
import MapboxMaps
import CoreLocation
 
class MapViewController: UIViewController {
 
    internal var mapView: MapView!
    
    var userLat = Double()
    var userLon = Double()
     
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoiZHJhZ29zcG9wMTQiLCJhIjoiY2w1YTRiaTQzMDRwcjNqbnhlMDljbnE0cyJ9.Vo7kwE79C6-S0Uu1ZofkiA")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, styleURI: StyleURI(rawValue: "mapbox://styles/dragospop14/cl5a6uj2u000k14ncz9jj8lyk"))
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         
        self.view.addSubview(mapView)
        
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
         
            let centerCoordinate = CLLocationCoordinate2D(
                latitude: 53.80091330890176, longitude: -1.539510459939681)
             
            let newCamera = CameraOptions(center: centerCoordinate,
            zoom: 12.0,
            bearing: 0,
            pitch: 0)
             
            self.mapView.camera.ease(to: newCamera, duration: 2.0)
            
            let pointAnnotationManager = self.mapView.annotations.makePointAnnotationManager()
            pointAnnotationManager.delegate = self
            
            var pointAnnotation = PointAnnotation(coordinate: centerCoordinate)

            pointAnnotation.image = .init(image: UIImage(systemName: "mappin")!, name: "mappin")
            pointAnnotation.iconAnchor = .bottom

            pointAnnotationManager.annotations = [pointAnnotation]
            
        }
    }
    
    func openSheet(){
        //let obj = BusinessDetailsSheetViewController(nibName: nil, bundle: nil)
        //let obj = BusinessDetailsViewController(nibName: nil, bundle: nil)
        //let obj = self.storyboard?.instantiateViewController(withIdentifier:"BusinessDetailsViewController") as! BusinessDetailsViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
        
        if #available(iOS 15.0, *) {
            let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .pageSheet

                if let sheet = nav.sheetPresentationController {

                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 25
                    sheet.largestUndimmedDetentIdentifier = .medium

                }
            
            DatabaseManager.shared.db.collection("Businesses").getDocuments() { documents, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    do{
                        for document in documents!.documents {
                            let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                            let business = try JSONDecoder().decode(Business.self, from: data)
                            obj.business = business
                        }
                    } catch {
                        print("Business error  \(error)")
                    }
                }
            }
            
            
            present(nav, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        

        
    }
}

extension MapViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        print("Annotations tapped: \(annotations)")
        openSheet()
    }
}
