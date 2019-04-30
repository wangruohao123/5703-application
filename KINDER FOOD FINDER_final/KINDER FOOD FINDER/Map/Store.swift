//
//  Store.swift
//  StoreLocation
//
//  Created by mint on 2019/4/28.
//  Copyright © 2019 mint. All rights reserved.
//

import Foundation

import MapKit

import Contacts // Contains dictionary key constants such as CNPostalAddressStreetKey, for when you need to set the address, city or state fields of a location.

class Store: NSObject, MKAnnotation { //To adopt the MKAnnotation protocol, Artwork must subclass NSObject, because MKAnnotation is an NSObjectProtocol.
    let title: String? //To display a title when the user taps a pin.
    let coordinate: CLLocationCoordinate2D //The MKAnnotation protocol requires the coordinate property.
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
    
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        // Create an MKMapItem from an MKPlacemark.
        let addressDict = [CNPostalAddressStreetKey: title!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
        //The Maps app is able to read this MKMapItem, and display the right thing.
    }
    
}

