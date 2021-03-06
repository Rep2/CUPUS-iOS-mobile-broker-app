//
//  SocketBindTest.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 06/06/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import XCTest
@testable import CUPUS_Mobile_broker

class SocketBindTest:XCTestCase {
    
    func testSocketBindAnyAddres() throws{
        do{
            let socket = try TCPSocket()
            
            let addr = SocketAddress(port: 8080)
            
            try socket.bind(addr)
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testSocketBindStringAdressSuccess() throws{
        do{
            let socket = try TCPSocket()
            
            let addr = try SocketAddress(ip: "127.0.0.1",port: 8080)
            
            try socket.bind(addr)
            
            XCTAssert(true)
        }catch SocketError.BindFailed{
            XCTAssert(false)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testSocketBindStringAdressFail() throws{
        do{
            let socket = try TCPSocket()
            
            let addr = try SocketAddress(ip: "127.5.6.12",port: 8080)
            
            try socket.bind(addr)
            
            XCTAssert(false)
        }catch SocketError.BindFailed{
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testListenSocketBind(){
        do{
            _ = try TCPServerImplementation.Create(8888)
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
        
    }
    
}