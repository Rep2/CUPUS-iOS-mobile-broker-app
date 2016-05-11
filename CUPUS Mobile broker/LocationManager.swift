//
//  LocationManager.swift
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 Rep. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    static let instance = LocationManager()
    
    var isAvailable = false
    var status:CLAuthorizationStatus
    
    private var lastLocation: CLLocation?
    private var locationManager:CLLocationManager?
    
    private var updateSubscriptions: [String : (CLLocation?, Bool) -> Void] = [:]
    private var temporarySubscriptions: [(CLLocation?, Bool) -> Void] = []
    
    override init(){
        status = CLLocationManager.authorizationStatus()
        
        super.init()
        
        // Detect if user disabled location services for this app
        if status == .Restricted || status == .Denied{
            print("Location services are disabled for this app")
        }else{
            // Detect if user disabled location services for the whole phone
            // If so, still create location manager and start listening as data will come in if user enables service
            if (CLLocationManager.locationServicesEnabled() == false){
                 print("Location services are disabled for the whole phone")
            }
            
            initLocationManger()
            
            // If status is not determined ask user to allow it
            if status == .NotDetermined{
                // Or set to requestWhenInUseAuthorization
                locationManager!.requestAlwaysAuthorization()
            }else{
                // Location is available and working
                isAvailable = true
                locationManager!.startUpdatingLocation()
            }
        }
    }
    
    func initLocationManger(){
        // Init and store location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        // Set accuracy as wanted
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        self.status = status
        
        switch status{
        case .Denied, .Restricted:
            locationManager = nil
            
            isAvailable = false
            sendToSubscribers()
        case .NotDetermined:
            locationManager!.requestAlwaysAuthorization()
            
            isAvailable = false
            sendToSubscribers()
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            if locationManager == nil{
                initLocationManger()
            }
            
            isAvailable = true
            locationManager!.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations[0]
        
        sendToSubscribers()
    }
    
    func sendToSubscribers(){
        for (_, function) in updateSubscriptions{
            function(lastLocation, isAvailable)
        }
        
        for function in temporarySubscriptions{
            function(lastLocation, isAvailable)
        }
        temporarySubscriptions.removeAll()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    /// Initializes get location request
    /// Location is returned using provided retFunc
    func getLocation(retFunc: (CLLocation?, Bool) -> Void){
        
        if lastLocation != nil || isAvailable == false{
            retFunc(lastLocation, isAvailable)
        }else{
            temporarySubscriptions.append(retFunc)
        }
        
    }
    
    /// Initializes get location request and creates new subscription
    /// Location is returned using provided retFunc
    func getLocationAndSubscribe(name:String, retFunc: (CLLocation?, Bool) -> Void){
        retFunc(lastLocation, isAvailable)
        
        updateSubscriptions[name] = retFunc
    }
    
    func removeSubscription(name:String){
        updateSubscriptions[name] = nil
    }
    
}