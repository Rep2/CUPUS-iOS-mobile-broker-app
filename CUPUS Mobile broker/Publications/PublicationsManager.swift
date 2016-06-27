//
//  PublicationsManager.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/24/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

enum PublicationsManagerError: ErrorType{
    
    case PublisherNotConnected
}

class PublicationsManager{
    
    static let instance = PublicationsManager()
    
    var publisher:CUPUSPublisher!
    
    
    func connect() throws{
        if publisher == nil{
            publisher = try CUPUSPublisher(serverIP: Context.instance.serverIP, serverPort: Context.instance.serverPort)
        }
        
        try publisher!.connect()
    }
    
    func send(message:CUPUSMessage) throws{
        
        if publisher == nil{
            throw PublicationsManagerError.PublisherNotConnected
        }
        
        try publisher!.sendPublication(message)
    }
}