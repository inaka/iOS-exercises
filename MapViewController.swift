//
//  MapViewController.swift
//  GeoFlickr
//
//  Created by Oscar Otero on 12/9/16.
//  Copyright © 2016 Richard Turton. All rights reserved.
//

import Foundation
import MapKit


class MapViewController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate  {
    
    @IBOutlet var mapView:MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let circle = FlickrLocation.sharedInstance.circle
        mapView.centerCoordinate = FlickrLocation.sharedInstance.location.coordinate
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(
            FlickrLocation.sharedInstance.location.coordinate, CLLocationDistance(circle), CLLocationDistance(circle))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
}
