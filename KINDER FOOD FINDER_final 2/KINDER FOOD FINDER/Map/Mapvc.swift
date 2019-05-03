//
//  ViewController.swift
//  StoreLocation
//
//  Created by mint on 2019/4/28.
//  Copyright © 2019 mint. All rights reserved.
//



import UIKit
import MapKit
import CoreLocation
//Access to classes that begin with MK (Map Kit) and CL (Core Location).



class Mapvc : UIViewController, UISearchBarDelegate{
    var Rawdata : Rawdata!
    @IBOutlet weak var AvaLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var TextLabel: UITextView!
    let locationManger = CLLocationManager()
    //The CLLocationManager variable gives you access to the location manager throughout the  scope of the controller.
    
    let regionInMeters: Double = 1000
    
    //let initialLocation = CLLocation(latitude: -33.8634, longitude: 151.211)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextLabel?.text = Rawdata.availability
        // Do any additional setup after loading the view.
        checkLocationServices()
        mapView.delegate = self  // setting ViewController as the delegate of the map view
        
    }
    
    func setupLocationManger(){
        locationManger.delegate = self
        locationManger.desiredAccuracy=kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation(){
        if let location=locationManger.location?.coordinate{
            let region=MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            //setup our location manager
            setupLocationManger()
            checkLocationAuthorization()
            locationManger.startUpdatingLocation()
        }else{
            
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            
            break
        case .denied:
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        // break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        present(searchController, animated: true, completion: nil)
    }
    
    //search function

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()//Tells the receiver to suspend the handling of touch-related events.
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray//Gray circle
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true// the receiver sets its isHidden property (UIView) to true when receiver is not animating.
        activityIndicator.startAnimating()// Starts the animation from the first image in the list.
        
        self.view.addSubview(activityIndicator)//Add it to the view.
        
        
        searchBar.resignFirstResponder()//Notifies this object that it has been asked to relinquish its status as first responder in its window.
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()//create an MKLocalSearchRequest object when you want to search for map locations based on a natural language string.
        searchRequest.naturalLanguageQuery = searchBar.text//set the naturalLanguageQuery property to an appropriate search string
        
        //The latitude and longitude associated with a location
        guard let location: CLLocationCoordinate2D = locationManger.location?.coordinate else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)//The width and height of a map region. Use the delta values in this structure to indicate the desired zoom level of the map
        searchRequest.region = MKCoordinateRegion(center: location, span: span)//A rectangular geographic region centered around a specific latitude and longitude.
        
        
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        
        activeSearch.start {
            (response,error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                //If the location name of the search is wrong, the map cannot find the location. There will be a prompt.
                let alertToast = UIAlertController(title: "Reminder", message: "No nearby store was found.", preferredStyle: .alert)//An object that displays an alert message to the user.
                self.present(alertToast, animated: true, completion: nil)
                //Automatically disappears after two seconds
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    alertToast.dismiss(animated: false, completion: nil)
                }// Manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.
                print("Error")
                
            }
            else {
                for item in response!.mapItems {
                    self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                    
                    
                }
            }
        }
    }
    
    
    
}


//The Location Manager Delegate methods process Location Manager responses. There will be responses to the authorization and location requests you sent earlier in viewDidLoad.
extension Mapvc: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {//This gets called when location information comes back.
        guard let location=locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        //This method gets called when the user responds to the permission dialog. If the user chose Allow, the status becomes CLAuthorizationStatus.AuthorizedWhenInUse.
        
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            //            let annotation = MKPointAnnotation()
            //            annotation.coordinate = location
            //            annotation.title = title
            
            let _annotation = Store(title: title, coordinate: location)
            
            
            mapView.addAnnotation(_annotation)
            
            //myMapView.register(MapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
    }
    
    
    
}




extension Mapvc: MKMapViewDelegate {
    //ViewController will be the delegate for the map view.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Configure the annotation view is to implement the map view’s mapView(_:viewFor:) delegate method.
        
        guard let annotation = annotation as? Store else { return nil }
        //Check that this annotation is an Store object. If it isn’t, return nil to let the map view use its default annotation view.
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        //To make markers appear, create each view as an MKMarkerAnnotationView.
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            // Check to see if a reusable annotation view is available before creating a new one.
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            //Here create a new MKMarkerAnnotationView object, if an annotation view could not be dequeued.
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //   view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            
            mapsButton.setBackgroundImage(UIImage(named: "map_Image"), for: UIControl.State())
            view.rightCalloutAccessoryView = mapsButton
            
        }
        
        
        return view
    }
    
    
    //When the user taps a map annotation marker, the callout shows an info button. If the user taps this info button, the mapView(_:annotationView:calloutAccessoryControlTapped:) method is called.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Store
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]//The DirectionModeKey is set to Driving.
        location.mapItem().openInMaps(launchOptions: launchOptions)
        // Grab the Store object that this tap refers to, and then launch the Maps app by creating an associated MKMapItem, and calling openInMaps(launchOptions:) on the map item.
    }
    
    
}

