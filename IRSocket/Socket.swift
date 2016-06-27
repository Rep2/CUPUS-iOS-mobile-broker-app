//
//  IRSocket.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation
#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

enum SocketError: ErrorType{
    case SocketCreation(message: String)
    case BindFailed(error: Int32)
    case CloseFailed(error: Int32)
    case GetNameFailed(error: Int32)
    case ListenFailed(message:String)
    case ConnectFailed
    case SendError(message: String)
    case RecieveError(message: String)
    case CloseError
    case SetKeepAliveError
}

/// Basic C socket binding
class Socket{
    
    /// C socket
    internal let cSocket:Int32
    
    /**
     Creates UDP socket
     
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
    */
    static func UDPSocket() throws -> Socket{
        return try Socket(domain: AF_INET, type: SOCK_DGRAM, proto: 0)
    }
    
    
    /** Creates new instance of IRSocket containing C socket
     - Returns: IRSocket nil if creation fails
    
     - Throws: 'IRSocketError.SocketCreation' on socket creation failed
    */
    init(domain:Int32, type:Int32, proto:Int32) throws{
        cSocket = socket(domain, type, proto)
        
        if cSocket == -1{
            throw SocketError.SocketCreation(message: "Socket creation failed")
        }
    }
    
    func keepAlive() throws {        
        var optval:Int32 = 1
        var optlen = UInt32(sizeofValue(optval))
        
        if(setsockopt(cSocket, SOL_SOCKET, SO_KEEPALIVE, &optval, optlen) < 0) {
            try closeSocket();
            throw SocketError.SetKeepAliveError
        }
        
        
        /* Check the status for the keepalive option */
        if(getsockopt(cSocket, SOL_SOCKET, SO_KEEPALIVE, &optval, &optlen) < 0)
        {
            try closeSocket();
            throw SocketError.SetKeepAliveError

        }
        
        print("SO_KEEPALIVE is \(optval != 0 ? "ON" : "OFF")");
        
    }
    
    func closeSocket() throws{
        let success = close(cSocket)
        
        if success != 0{
            throw SocketError.CloseError
        }
    }

    
    /** 
     Binds socket to addres and updates address
     
     - Parameter addr: Binding address
 
     - Throws: IRSocketError on bind fail
    */
    func bind(addr:SocketAddress) throws{
        let bind = withUnsafePointer(&addr.cSockaddr) {
            Darwin.bind(cSocket, UnsafePointer<sockaddr>($0), 16)
        }
        
        if bind != 0{
            throw SocketError.BindFailed(error: bind)
        }
    }

    
    
    
    
    /// Updates addr to correct value
    /// - Parameter addr: Binding address
    ///
    /// - Throws: IRSocketError
    func getName(addr:SocketAddress) throws{
        var src_addr_len = socklen_t(sizeofValue(socket))
        
        let err = withUnsafePointer(&addr.cSockaddr) {
            return getsockname(self.cSocket, UnsafeMutablePointer($0), &src_addr_len)
        }
        
        if err == -1{
            throw SocketError.GetNameFailed(error: err)
        }

    }
    
    
    /// Recives data from socket and returns it unmodified
    /// If no data is available call waits for message to arive
    ///
    /// - Parameter maxLen: maximum data length in bytes
    /// - Parameter flag: check http://linux.die.net/man/2/recvfrom
    /// - Return: recived byte array
    func recive(maxLen: Int = 500, flag: Int32 = 0) -> Array<UInt8>{
        let buffer = Array<UInt8>(count: maxLen, repeatedValue: 0)
        
        let count = recv(cSocket, UnsafeMutablePointer<Void>(buffer), maxLen, flag)
        
        return Array(buffer[0..<count])
    }
    
    
    /// Recives data from socket and returns it unmodified toghether with sender address
    /// If no data is available call waits for message to arive
    ///
    /// - Parameter maxLen: maximum data length in bytes
    /// - Parameter flag: check http://linux.die.net/man/2/recvfrom
    /// - Return: recived byte array and sender address
    func reciveAndStoreAddres(maxLen: Int = 500, flag: Int32 = 0) -> (Array<UInt8>, SocketAddress){
        let buffer:Array<UInt8> = Array(count: maxLen, repeatedValue: 0)
        
        var sockLen = socklen_t(16)
        var addr = sockaddr_in()

        let count = withUnsafeMutablePointer(&addr) {
            recvfrom(cSocket , UnsafeMutablePointer<Void>(buffer), maxLen, flag, UnsafeMutablePointer($0), &sockLen)
        }
        
        return (Array(buffer[0..<count]), SocketAddress(cSocket: addr))
    }
    
    
    func sendTo(addr:SocketAddress, string:String){
        
        string.withCString { cstr -> Void in
            withUnsafePointer(&addr.cSockaddr) { ptr -> Void in
                let addrptr = UnsafePointer<sockaddr>(ptr)
                
                sendto(cSocket, cstr, string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), 0, addrptr, socklen_t(addr.cSockaddr.sin_len))
            }
        }
        
    }
    
    

    
    /// Closes socket
    deinit{
        do{
            try closeSocket()
        }catch{
            print("Socket close failed")
        }
    }
}