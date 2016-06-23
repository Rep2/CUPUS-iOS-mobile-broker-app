//
//  SocketSendTest.swift
//  CUPUS Mobile broker
//
//  Created by Macbook Pro 1 on 06/06/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import XCTest
@testable import CUPUS_Mobile_broker

class SocketSendTest:XCTestCase {

    
    func testConnect(){
        do{
            let serverSocket = try TCPServerImplementation.Create(8000)
            try serverSocket.startListening({ (recievedText) in
                print(recievedText)
            })
            
            _ = try TCPClientImplementation.Create(SocketAddress(port: 8000))
            
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testConnectFail(){
        do{
            _ = try TCPClientImplementation.Create(SocketAddress(port: 18000))
            
            XCTAssert(false)
        }catch SocketError.ConnectFailed{
            XCTAssert(true)
        }
        catch{
            XCTAssert(false)
        }
    }
    
    func testSend(){
        do{
            let serverSocket = try TCPServerImplementation.Create(8001)
            try serverSocket.startListening({ (recievedText) in
                print(recievedText)
            })
            
            let clientSocket = try TCPClientImplementation.Create(SocketAddress(port: 8001))
            let sentCount = try clientSocket.send("Test send")
            
            XCTAssert(sentCount == 9)
        }catch{
            XCTAssert(false)
        }
    }
    
    
}
