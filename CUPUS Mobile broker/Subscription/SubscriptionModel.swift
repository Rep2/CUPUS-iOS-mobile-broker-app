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
    
    
    func connect(serverIP:String, serverPort:UInt16) throws{
        if subscriber == nil{
            subscriber = try Subscriber(serverIP: serverIP, serverPort: serverPort)
        }
        
        try subscriber.connect(){
            (success:Bool) -> Void in
            
        }
    }
    
    func send(subscription: CUPUSMessage) throws{
        if subscriber == nil{
            print("Subscription manager not connected")
            return
        }
        
        try subscriber.sendSubscription(subscription)
    }
    
    func listen() throws{
        if subscriber == nil{
            print("Subscription manager not connected")
            return
        }
        
        try subscriber.listen()
    }
    
    
    func addSubscriptions(subscription: SubscriptionModel){
        subscriptions.append(subscription)
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
    
    func sendSubscription() throws{
        
        var types = [CUPUSValueType]()
        
        if subscriptionTypes.contains(SensorSubscriptionOptions.NoiseLevel){
            types.append(CUPUSValueType.NoiseSensor)
            
            if subscriptionTypes.count > 1{
                types.append(CUPUSValueType.CUPUSSensor)
            }
        }else if subscriptionTypes.count > 0{
            types.append(CUPUSValueType.CUPUSSensor)
        }
        
        var coordinates = [[Double]]()
        
        switch type{
        case .Follow:
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
        case let .Pick(center: center, radius: radius):
            coordinates = createPolygonFromCenterAndDistance(center, distanceInMeters: radius)
        }
     
        
        let subscription = Subscriber.createSubscriptionModel(types, startTime: Int(NSDate.timeIntervalSinceReferenceDate()), coordinates: coordinates)
        
     
        try SubscriptionManager.instance.send(subscription)
        
        
    }
    
}