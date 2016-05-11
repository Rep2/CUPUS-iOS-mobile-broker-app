//
//  SensorsDetector.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 11/05/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import CoreLocation

enum Sensors: String{
    case AudioRecorder = "Audio recorder"
    case ExternalDevices = "External bluetooth devices"
}

class SensorsDetector{
    
    static var instance:SensorsDetector!
    
    var sensors = [Sensors:Bool?]()
    
    var controller: PublishViewController
    
    var location:CLLocationCoordinate2D?
    
    init(controller: PublishViewController){
        sensors[.AudioRecorder] = nil
        sensors[.ExternalDevices] = true
        
        self.controller = controller
        
        detectSensors()
        
        LocationManager.instance.getLocationAndSubscribe("SensorsDetector", retFunc: reciveLocation)
    }
    
    func reciveLocation(location: CLLocation?, isAvailable:Bool){
        if let location = location{
            self.location = location.coordinate
            controller.locationAvailable = true
            checkSensorsInitialized()
        }
        
        if isAvailable == false && location == nil{
            controller.locationAvailable = false
        }
    }
    
    func detectSensors(){
        if(AudioLevelRecording.instance.isAvailable == nil || AudioLevelRecording.instance.isAvailable == false){
            AudioLevelRecording.instance.checkIfAvailable({ (available) in
                self.sensors[.AudioRecorder] = available
                
                self.checkSensorsInitialized()
            })
        }else{
            sensors[.AudioRecorder] = true
        }
        
        checkSensorsInitialized()
    }
    
    // Checks if sensors are initializes and if so, notifies the view controller
    func checkSensorsInitialized(){
        for sensor in [Sensors.AudioRecorder, Sensors.ExternalDevices]{
            if sensors[sensor] == nil{
                return
            }
        }
        
        if location != nil{
            controller.setTable()
        }
    }
}