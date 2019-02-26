//
//  CarloudyLocation.swift
//  CarloudyiOS
//
//  Created by Zijia Zhai on 6/12/18.
//  Copyright © 2018 Cognitive AI Technologies. All rights reserved.
//

import UIKit
import CoreLocation

public protocol CarloudyLocationDelegate {
    func carloudyLocation(speed : CLLocationSpeed)
    func carloudyLocation(locationName: String, street: String, city: String, zipCode: String, country: String)
}

open class CarloudyLocation: NSObject, CLLocationManagerDelegate{
    
    open lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0  // Movement threshold for new events
        //  _locationManager.allowsBackgroundLocationUpdates = true // allow in background

        return _locationManager
    }()
    
    var currentSpeed = 0.0
    open var sendAddressDelayTimes = 5
    var sendAddressDelayTimesIndex = 0
    open var sendSpeed : Bool
    open var sendAddress : Bool
    open var delegate : CarloudyLocationDelegate?
    
    public init(sendSpeed : Bool = true, sendAddress : Bool = false) { //, desireAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
        self.sendSpeed = sendSpeed
        self.sendAddress = sendAddress
        
        super.init()
//        locationManager.desiredAccuracy = desireAccuracy
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.speed ?? 0)
        if sendSpeed{
            self.delegate?.carloudyLocation(speed: (manager.location?.speed) ?? 0)
        }
        if sendAddress && sendAddressDelayTimesIndex == 0{
            reverseCoordinateToAddress(latitude: (locations.last?.coordinate.latitude)!, longtitude: (locations.last?.coordinate.longitude)!)
        }
        sendAddressDelayTimesIndex += 1
        if sendAddressDelayTimesIndex == sendAddressDelayTimes{
            sendAddressDelayTimesIndex = 0
        }
        
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func reverseCoordinateToAddress(latitude: CLLocationDegrees, longtitude : CLLocationDegrees){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longtitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error != nil{
                print(error!)
                return
            }
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            var locationName = ""
            var streetName = ""
            var cityName = ""
            var zipName = ""
            var countryName = ""
            var subThoroughfare = ""
            
            //            print(placeMark.name)
            //            print(placeMark.description)
            
            if let subThoroughfareTemp = placeMark.subThoroughfare{
                subThoroughfare = subThoroughfareTemp
            }
            
            // Location name
            if let locationN = placeMark.location {
                locationName = String(describing: locationN)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
                streetName = street
            }
            // City
            if let city = placeMark.locality {
                print(city)
                cityName = city
            }
            
            // Zip code
            if let zip = placeMark.postalCode {
                print(zip)
                zipName = zip
            }
            // Country
            if let country = placeMark.country {
                print(country)
                countryName = country
            }
            self.delegate?.carloudyLocation(locationName: subThoroughfare, street: streetName, city: cityName, zipCode: zipName, country: countryName)
        })
    }
}







