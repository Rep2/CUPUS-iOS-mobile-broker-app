//
//  SocketConnector.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 06/06/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

class SocketConnector{
    
    func connect() throws{
        
        let socket = try IRSocket(domain: AF_INET, type: SOCK_DGRAM, proto: 0)
        
        do{
            // Binds socket to OS given address
            let addr = IRSockaddr()
            try socket.bind(addr)
            
            print("socket bind succeded")
            
        }catch IRSocketError.BindFailed{
            print("Socket bind failed")
            exit(1)
            
        }catch{
            print("Get name failed")
            exit(1)
        }
    }
    
    
}