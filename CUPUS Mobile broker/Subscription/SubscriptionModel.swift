//
//  Subscription.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import CoreLocation

struct CircleData{
    let center: CLLocationCoordinate2D
    let radius: Double
}

enum SubscriptionType: Equatable{
    case Follow
    case Pick(center: CLLocationCoordinate2D, radius: Double)
    

}

func ==(lhs: SubscriptionType, rhs: SubscriptionType) -> Bool {
    
    switch (lhs, rhs) {
    case ( .Pick(_, _), .Pick(_, _)):
        return true
    case ( .Follow, .Follow):
        return true
    default:
        return false
    }
    
}

class SubscriptionManager{
    
    static let instance = SubscriptionManager()
    
    var subscriptions = [SubscriptionModel]()
    
    var subscriber:Subscriber!
    
    func addSubscriptions(subscription: SubscriptionModel){
        subscriptions.append(subscription)
    }
    
    
    func connect(serverIP:String, serverPort:UInt16) throws{
        if subscriber == nil{
            subscriber = try Subscriber(serverIP: serverIP, serverPort: serverPort)
        }
        
        try subscriber.connect()
    }
    
}

class SubscriptionModel{
    
    var type:SubscriptionType
    var subscriptionTypes: [SensorSubscriptionOptions]
    
    init(type:SubscriptionType, types: [SensorSubscriptionOptions] = []){
        subscriptionTypes = types
        self.type = type
    }
    
    func optionPressed(type: SensorSubscriptionOptions){
        if subscriptionTypes.contains(type){
            subscriptionTypes.removeAtIndex(subscriptionTypes.indexOf(type)!)
        }else{
            subscriptionTypes.append(type)
        }
    }
    
    func sendSubscription(){
        
        var types = [CUPUSValueType]()
        
        if subscriptionTypes.contains(SensorSubscriptionOptions.CO2) || subscriptionTypes.contains(SensorSubscriptionOptions.O2) || subscriptionTypes.contains(SensorSubscriptionOptions.Temperature){
            types.append(CUPUSValueType.CUPUSSensor)
        }
        
        if subscriptionTypes.contains(SensorSubscriptionOptions.Noise){
            types.append(CUPUSValueType.NoiseSensor)
        }
        
        var coordinates = [[Double]]()
        
        if type == .Follow{
            LocationManager.instance.getLocation({ (location, success) in
                
                if !success{
                    print("could not get last location")
                }else{
                    
                    if let location = location{
                        coordinates = createPolygonFromCenterAndDistance(location.coordinate, distanceInMeters: 1000)
                    }else{
                        print("location not sent")
                    }
                }
                
            })
        }else{
            
        }
        
        
        let subscription = Subscriber.createSubscriptionModel(types, startTime: Int(NSDate.timeIntervalSinceReferenceDate()), coordinates: coordinates)
        
    }
    
}