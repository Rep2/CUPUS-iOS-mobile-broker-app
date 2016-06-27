//
//  Publisher.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/24/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation
import Unbox
import Wrap

struct PublisherModel: Unboxable{
    let en:String
    let id:String
    
    init(unboxer: Unboxer){
        self.id = unboxer.unbox("id")
        self.en = unboxer.unbox("en")
    }
    
    init(id:String, en:String){
        self.id = id
        self.en = en
    }
}

class CUPUSPublisher{
    
    let model:PublisherModel
    
    var tcpClient:TCPClient!
    var socketAddress: SocketAddress

    
    let serverIP:String
    let serverPort:UInt16
    
    init(serverIP:String, serverPort: UInt16, name:String? = nil) throws {
        self.serverIP = serverIP
        self.serverPort = serverPort
        
        model = PublisherModel(id: NSUUID().UUIDString, en: name ?? randomStringWithLength(10) as String)
        
        socketAddress = try SocketAddress(ip: serverIP, port: serverPort)
    }
    
    func connect() throws{
        if tcpClient == nil{
            tcpClient = try TCPClientImplementation.Create()
        }
      
        try tcpClient.connectTo(socketAddress) {
            (success: Bool) -> Void in
            
            if success{
                print("Publisher connected to the server")
                
                do{
                    let registerMessage = NSString(data: try Wrap(self.model), encoding: NSUTF8StringEncoding)! as String
                    
                    try self.tcpClient.send(registerMessage)
                }catch{
                    
                }
            }else{
                print("Publisher failed to connect to the server")
            }
        }
    }
    
    func connect(serverIP:String, serverPort: UInt16) throws{
        socketAddress = try SocketAddress(ip: serverIP, port: serverPort)
        
        try connect()
    }
    
    func sendPublication(subscription:CUPUSMessage) throws{
        let data:NSData = try Wrap(subscription)
        let subscribeMessage = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        
        try tcpClient.send(subscribeMessage)
        
        print("Sent publication " + subscribeMessage)
    }
    
    static func createPublication(type: CUPUSValueType, startTime: Int, coordinates: [Double]) -> CUPUSMessage{
        
        let property = PublicationProperty(type: type.rawValue, id: "52323", co: "20")
        
        let geometry = Geometry(coordinates: [
            [2.0, 2.0],
            [3.0, 3.0]], type: "LineString")
        
        let feature = Feature(geometry: geometry, properties: property)
        
        let payload = Payload(features: [feature])
        
        let subscriptionModel = CUPUSMessage(payload: payload, startTime: startTime, validity: -1)
        
        return subscriptionModel
    }
    
}