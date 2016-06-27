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
    
    var connected = false
    
    init(serverIP:String, serverPort:UInt16, name:String? = nil) throws{
        model = SubscriberModel(
            id: NSUUID().UUIDString,
            en: name ?? randomStringWithLength(10) as String,
            ip: serverIP,
            port: Int(serverPort))
        
        tcpClient = try TCPClientImplementation.Create()
    }
    
    func connect(callback: (success:Bool) -> Void) throws{
        connected = false
        
        let socketAddress = try SocketAddress(ip: model.ip, port: UInt16(model.port))
        
        try tcpClient.connectTo(socketAddress){
            (success: Bool) -> Void in
            
            if success{
                print("Subscriber connected to the server")
                
                do{
                    let connectMessageData: NSData = try Wrap(self.model)
                    let connectMessage = NSString(data: connectMessageData, encoding: NSUTF8StringEncoding)! as String
                    
                    try self.tcpClient.send(connectMessage)
                    
                    print("Subscriber registered")
                    callback(success: true)
                    
                    self.connected = true
                }catch{
                    print("Subscriber failed to register")
                    callback(success: false)
                }
                
            }else{
                print("Subscriber failed to connect to the server")
                callback(success: false)
            }
        }
    }
    
    
    
    func sendSubscription(subscription:CUPUSMessage) throws{
        let data:NSData = try Wrap(subscription)
        let subscribeMessage = NSString(data: data, encoding: NSUTF8StringEncoding)! as String

        try tcpClient.send(subscribeMessage)
        
        print("Sent subscription " + subscribeMessage)
    }
    
    static func createSubscriptionModel(types: [CUPUSValueType], startTime: Int, coordinates: [[Double]]) -> CUPUSMessage{
        
        var predictMaps = [String]()
        
        for type in types{
            predictMaps.append("{\"value\":\"\(type.rawValue)\",\"key\":\"Type\",\"operator\":\"EQUAL\"}")
        }
        
        let property = SubscriptionProperty(predicateMap: predictMaps, stringAttributeBorders: StringAttributeBorder())
        
        let geometry = Geometry(coordinates: [
            [1.0, 3.0],
            [3.0, 1.0],
            [3.0, 3.0],
            [1.0, 3.0]], type: "Polygon")
        
        let feature = Feature(geometry: geometry, properties: property)
        
        let payload = Payload(features: [feature])
        
        let subscriptionModel = CUPUSMessage(payload: payload, startTime: startTime, validity: -1)
        
        return subscriptionModel
    }
    
    func listen() throws{
        
        writeToLog(LogFiles.Subscriber.rawValue, content: "Subscriber start listen \(NSDate())")
        
        print("Listening")
        
        try tcpClient.recieveAsync { (recievedString) in
            
            dispatch_async(dispatch_get_main_queue(), { 
                writeToLog(LogFiles.Subscriber.rawValue, content: "Recieved subscription \(recievedString) \(NSDate())")
                
                print("Recieved subscription \(recievedString) ")
            })
            
        }
        
    }
}