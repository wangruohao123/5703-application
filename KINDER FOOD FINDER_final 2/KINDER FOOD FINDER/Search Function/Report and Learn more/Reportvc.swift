//
//  Reportvc.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2/5/19.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Reportvc: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var Rawdata : Rawdata!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var coordinateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var reportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        productNameLabel.text = Rawdata.product_name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        //createMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    //    func createMapView()
    //    {
    //        mapView = MKMapView()
    //
    //
    //
    //        //mapView.frame = CGRectMake(leftMargin, topMargin, mapWidth, mapHeight)
    //        mapView.frame = CGRect(x: 10, y: 60, width: view.frame.size.width-20, height: 300)
    //        mapView.mapType = MKMapType.standard
    //        mapView.isZoomEnabled = true
    //        mapView.isScrollEnabled = true
    //
    //        // Or, if needed, we can position map in the center of the view
    //        mapView.center = view.center
    //
    //        view.addSubview(mapView)
    //    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    //11111
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
            coordinateTextField.text = String(locationOnMap.longitude) + ", " + String(locationOnMap.latitude)
            print(locationOnMap.latitude)
            print(locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Some Title"
        annotation.subtitle = "Some Subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            //pinView!.pinTintColor = UIColor.black
        }
        else {
            //pinView!.removeFromSuperview()
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
                print("do something")
            }
        }
    }
    
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        let productId = String(Rawdata.id)
        let productName = Rawdata.product_name
        let coordinate = coordinateTextField.text
        let description = descriptionTextField.text
        
        if(productName.isEmpty||coordinate!.isEmpty||description!.isEmpty) {
            displayMyAlertMessage(userMessage: "All the field cannot be empty")
            return ;}
        // send user data to server side
        
        let myUrl = NSURL(string: "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/report/")
        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST"
        
        let postString = "product_id=\(productId ?? "")&product_name=\(productName ?? "")&coordinate=\(coordinate ?? "")&location_description=\(description ?? "")";

        request.httpBody = postString.data(using: String.Encoding.utf8);
        print(postString)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if error != nil{
                print("error=\(error)")
                return
            }
            let json = try? JSON(data: data!)
            print("___________")
            print(response ?? "")
            print(json ?? "")
            var err: NSError?
            do {
                
                let httpResponse = response as! HTTPURLResponse
                let code = httpResponse.statusCode
                var result: Double = Double(code)
                print(code)
                if(result == 400){
                    DispatchQueue.main.async(execute:{
                        var myAlert = UIAlertController(title: "Alert", message: "something wrong ", preferredStyle: UIAlertController.Style.alert);
                        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default,handler:nil)
                        myAlert.addAction(okAction);
                        self.present(myAlert, animated:true, completion:nil);
                        return;
                    })
                }
                if(result==201){
                    DispatchQueue.main.async(execute:{
                        self.displayMyAlertMessage(userMessage: "Report successful")
                    })
                }
            }
            catch{
                return
            }
            
            
    }
        task.resume()
    }
    func displayMyAlertMessage(userMessage:String){
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true,completion: nil)
    }


}
