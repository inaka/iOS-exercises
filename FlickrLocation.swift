//
//  FlickrLocation.swift
//  FlickrSearch
//
//  Created by Oscar Otero on 12/5/16.
//

import UIKit
import CoreLocation

class FlickrLocation: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance:FlickrLocation = FlickrLocation()
    var locationManager:CLLocationManager!
    var location:CLLocation!
    var city:String?
    var country:String?
    var neighborhood:String?
    var circle:UInt64 = 2000
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
    }
    
    func findMyLocation() {
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print ("Failed with some error", error!)
                return
            }
            
            if (placemarks?.count)! == 1 {
                let pm = placemarks?[0] as CLPlacemark!
                self.displayLocationInfo(placemark: pm)
                self.locationManager.stopMonitoringSignificantLocationChanges()
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            location = locationManager.location!
            city = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality : ""
            country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            neighborhood = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
            print (city!,"   ", neighborhood!)
            
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"LocationReady"),
                    object: nil,
                    userInfo:nil)
            
        }
        else {
            print ("No palcemarks")
        }

    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
