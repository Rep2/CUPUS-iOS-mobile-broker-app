//
//  IRSocketListener.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 06/06/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

protocol TCPServer {
    func startListening(callback:(String) -> Void) throws
}

class TCPServerImplementation: Socket, TCPServer{
    
    /**
     Creates TCP server socket and binds it to given port
     
     - Parameter: port UInt16 value of port on which socket will be bound
     - Returns: TCPServer bound to given port
     
     - Throws: 'SocketError.SocketCreation' on socket creation failed
     */
    static func Create(port: UInt16) throws -> TCPServer{
        let socket = try TCPServerImplementation(port: port)
        
        return socket
    }
    
    /**
     Creates TCP server socket and binds it to given port
     
     - Parameter: port UInt16 value of port on which socket will be bound
     
     - Throws: 'SocketError.SocketCreation' on socket creation failed
     */
    private init(port: UInt16) throws{
        try super.init(domain: AF_INET, type: SOCK_STREAM, proto: 0)
        
        let address = SocketAddress(port: port)
        
        try bind(address)
    }
    
    /**
     Starts listening on binded address
    */
    func startListening(callback:(String) -> Void) throws{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            repeat{
                if listen(self.cSocket, 10) == -1{
                    //throw SocketError.ListenFailed(message: "Listen funcion failed")
                }
                
                
                var socketLength = socklen_t(16)
                var clientAddress = sockaddr_in()
                
                let clientSocket = withUnsafeMutablePointer(&clientAddress) {
                    accept(self.cSocket, UnsafeMutablePointer($0), &socketLength)
                }
                
                if clientSocket < 0{
                   // throw SocketError.ListenFailed(message: "Accept socket failure")
                }
                
                let inBuffer = [UInt8](count: 1000, repeatedValue: 0)
                
                let n = read(clientSocket, UnsafeMutablePointer<Void>(inBuffer), 1000)
                
                if n < 0{
                  //  throw SocketError.ListenFailed(message: "Message length less than 0")
                }
                
                callback(String(bytes: inBuffer.prefix(n), encoding: NSUTF8StringEncoding)!)
            }while(true)
        }
        
    }
    
}