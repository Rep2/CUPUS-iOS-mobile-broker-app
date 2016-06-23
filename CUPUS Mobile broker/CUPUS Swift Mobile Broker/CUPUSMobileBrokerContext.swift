//
//  Context.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/22/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

class CUPUSMobileBrokerContext{
    
    static let instance = CUPUSMobileBrokerContext(serverIP: Context.instance.serverIP, serverPort: Context.instance.serverPort)
    
    let serverIP:String
    let serverPort:UInt16
    
    init(serverIP: String, serverPort: UInt16){
        self.serverIP = serverIP
        self.serverPort = serverPort
    }
    
    
    
}