//
//  Subscriber.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/22/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import Wrap
import Unbox

enum CUPUSValueType: String{
    
    case CUPUSSensor = "SensorReading"
    case NoiseSensor
    
}

struct SubscriberModel: Unboxable{
    
    let id: String
    let en: String
    
    let ip: String
    let port: Int
    
    init(unboxer: Unboxer){
        self.id = unboxer.unbox("id")
        self.en = unboxer.unbox("en")
        self.ip = unboxer.unbox("ip")
        self.port = unboxer.unbox("port")
    }
    
    init(id:String, en:String, ip:String, port:Int){
        self.id = id
        self.en = en
        self.ip = ip
        self.port = port
    }
}

class Subscriber{
    
    let model:SubscriberModel
    
    var tcpClient:TCPClient
    
    init(serverIP:String, serverPort:UInt16, name:String? = nil) throws{
        model = SubscriberModel(
            id: NSUUID().UUIDString,
            en: name ?? randomStringWithLength(10) as String,
            ip: serverIP,
            port: Int(serverPort))
        
        tcpClient = try TCPClientImplementation.Create()
    }
    
    func connect() throws{
        let socketAddress = try SocketAddress(ip: model.ip, port: UInt16(model.port))
        
        try tcpClient.connectTo(socketAddress)
        
        let connectMessageData: NSData = try Wrap(model)
        let connectMessage = NSString(data: connectMessageData, encoding: NSUTF8StringEncoding)! as String
        
        try tcpClient.send(connectMessage)
    }
    
    
    
    func sendSubscription(subscription:Subscription) throws{
        let data:NSData = try Wrap(subscription)
        let subscribeMessage = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        
        try tcpClient.send(subscribeMessage)
    }
    
    static func createSubscriptionModel(types: [CUPUSValueType], startTime: Int, coordinates: [[Double]]) -> Subscription{
        
        var predictMaps = [String]()
        
        for type in types{
            predictMaps.append("{\"value\":\"\(type.rawValue)\",\"key\":\"Type\",\"operator\":\"EQUAL\"}")
        }
        
        let property = Property(predicateMap: predictMaps, stringAttributeBorders: StringAttributeBorder())
        
        let geometry = Geometry(coordinates: coordinates, type: "Polygon")
        
        let feature = Feature(geometry: geometry, properties: property)
        
        let payload = Payload(features: [feature])
        
        let subscriptionModel = Subscription(payload: payload, startTime: startTime, validity: -1)
        
        return subscriptionModel
    }
    
    
    static func wrapSubscription(subscription: Subscription) throws -> NSData{
        let str:NSData = try Wrap(subscription)
        
        return str
        
    }
    

    
}