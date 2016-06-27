//
//  IRUDPSocket.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation


class TCPSocket: Socket{
    
    /**
     Creates TCP socket
     
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
     */
    init() throws{
        try super.init(domain: AF_INET, type: SOCK_STREAM, proto: 0)
    }
    
    /**
     Connect socket to given address
     
     - Parameter: address IRSockaddr address of listening TCP socket
     
     - Throws: 'SocketError.ConnectFailed' on failed connect
    */
    func connectTo(address: SocketAddress, callback: (success:Bool) -> Void){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { 
            let connectSuccess = withUnsafePointer(&address.cSockaddr) {
                connect(self.cSocket, UnsafePointer<sockaddr>($0), 16)
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                if connectSuccess != 0{
                    callback(success: false)
                }else{
                    callback(success: true)
                }
            })
        
        }
    }
    
   
    
}