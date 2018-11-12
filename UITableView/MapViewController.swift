//
//  MapViewController.swift
//  UITableView
//
//  Created by Konstantin on 06/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var restaurant: Restaurant!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first!
            
            let annotation = MKPointAnnotation()
            annotation.title = self.restaurant.name
            annotation.subtitle = self.restaurant.type
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        let annotationIdentifier = "restAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        //rightImage.image = UIImage(named: restaurant.image)
        rightImage.image = UIImage(data: restaurant.image! as Data) // image - binary data кастим до Data
        annotationView?.rightCalloutAccessoryView = rightImage
        
        annotationView?.pinTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        return annotationView
        
    }

}
