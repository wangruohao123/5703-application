//
//  ReportVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/03/29.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit
import MapKit
//import Firebase

class ReportVC: UITableViewController , CLLocationManagerDelegate , UITextFieldDelegate{

    var imageAdded = false
    
    @IBOutlet weak var map: MKMapView!

    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
// display current locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Location"
            map.addAnnotation(annotation)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "Thanks", message: "Thanks for you report", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){(action) in alertVC.dismiss(animated: true, completion: nil)}
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

