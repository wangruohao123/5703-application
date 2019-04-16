//
//  ReportVC.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/03/29.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit
import MapKit
//import Firebase

class ReportVC: UITableViewController , CLLocationManagerDelegate {
    
    
    
    var imageAdded = false
    
    @IBOutlet weak var map: MKMapView!

    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
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
//        if let email = Auth.auth().currentUser?.email {
//            let saveRequestDictionary : [String:Any] = ["email":email,"latitude":userLocation.latitude,"longitude":userLocation.longitude]
//            Database.database().reference().child("SaveRequests").childByAutoId().setValue(saveRequestDictionary)
//            print("save completed")
//            let alertVC = UIAlertController(title: "Report your Location", message: "Thanks", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default){(action) in alertVC.dismiss(animated: true, completion: nil)}
//            alertVC.addAction(okAction)
//            present(alertVC, animated: true, completion: nil)
//        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

