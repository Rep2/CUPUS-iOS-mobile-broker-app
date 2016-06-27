//
//  TCPClient.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/22/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation

enum TCPSendError: ErrorType{
    case NotSent
    case WholeMessageNotSent(sentLength: Int)
}

enum TCPRecieveError: ErrorType{
    case NoBytesRecieved
    case RecieveStartFailed
}

protocol TCPClient{
    func connectTo(address: SocketAddress, callback: (success:Bool) -> Void) throws
    
    func send(outString:String) throws -> Int
    
    func recieve() throws -> String
    func recieveAsync(callback: (String) -> Void) throws
}

class TCPClientImplementation: TCPSocket, TCPClient{
    
    /**
     Creates TCP socket and connects it to given address
     
     - Returns: TCPClient protocol
     
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
     */
    static func Create(address: SocketAddress, callback: (success:Bool) -> Void) throws -> TCPClient {
        let clientSocket = try TCPClientImplementation(address: address, callback: callback)
        
     //   try clientSocket.keepAlive()
        
        return clientSocket
    }
    
    /**
     Creates TCP socket
     
     - Returns: TCPClient protocol
     
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
     */
    static func Create() throws -> TCPClient {
        let clientSocket = try TCPClientImplementation()
        
    //    try clientSocket.keepAlive()
        
        return clientSocket
    }
    
    /**
     Creates TCP socket and connects it to given address
     
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
     */
    private init(address: SocketAddress, callback: (success:Bool) -> Void) throws{
        try super.init()
        
        connectTo(address, callback: callback)
    }
    
    /**
     Creates TCP socket
     
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
     */
    override private init() throws{
        try super.init()
    }
    
    
    /**
     Sends given string to connected socket
     
     - Parameter: outString string to be sent
     
     - Throws: 'TCPSendError.NotSent' if send failed and 0 bytes were sent
     - Throws: 'TCPSendError.WholeMessageNotSent' if not all bytes were sent
     */
    func send(outString:String) throws -> Int{
        
        return try outString.withCString { cstr -> Int in
            let lengthSent = write(cSocket, cstr, outString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            
            if lengthSent < 0{
                throw TCPSendError.NotSent
            }
            else if lengthSent < outString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding){
                throw TCPSendError.WholeMessageNotSent(sentLength: lengthSent)
            }
            
            return lengthSent
        }
    }
    
    
    func recieve() throws -> String{
        let inBuffer = Array<UInt8>(count: 1000, repeatedValue: 0)
        
        let n = read(cSocket, UnsafeMutablePointer<Void>(inBuffer), 1000)
        
        if n < 0{
            throw TCPRecieveError.NoBytesRecieved
        }
        
        return String(bytes: inBuffer.prefix(n), encoding: NSUTF8StringEncoding)!
    }
    
    
    var continueReciving = false
    
    func recieveAsync(callback: (String) -> Void) throws{
        continueReciving = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) { 
            
            repeat{
                do{
                    let str = try self.recieve()
                    
                    callback(str)
                }catch{
                    dispatch_async(dispatch_get_main_queue(), {
                        print("Start reviece failed")
                    })
                }
            }while(self.continueReciving)
        }
    }
    
    func stopRecieving(){
        continueReciving = false
    }
    
}