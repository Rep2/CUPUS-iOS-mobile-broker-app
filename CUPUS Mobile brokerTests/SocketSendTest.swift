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

    func testSend(){
        do{
            let socket = try TCPSocket()
            
            socket.sendTo(IRSockaddr(port: 8889), string: "Message")
            
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testConnect(){
        do{
            let socket = try TCPSocket()
            
            try socket.bind(IRSockaddr(port: 8000))
            
            try socket.connectTo(IRSockaddr(port: 10000))
            
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testSubscribe(){
        do{
            let socket = try TCPSocket()
            
            try socket.connectTo(IRSockaddr(port: 10000))
            
            let outString = "{\"eid\":\"aa596564-a3de-4645-964b-36581501cbeb\",\"id\":\"e1e5b1eb2d71f5da8c6600e3889349cf\",\"type\":\"SubscriberTcpRegisterMessage\",\"message\":\"{\"port\":0,\"ip\":\"10.201.17.170\",\"en\":\"Subscriber\",\"id\":\"aa596564-a3de-4645-964b-36581501cbeb\"}\",\"timestamp\":1465301410588}"
            let outLength = outString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            
            let lengthSent = try socket.send(outString)
            
            XCTAssert(outLength == lengthSent)
            
            var ret = socket.recive()
            
            print(ret)
            
            var string = String(bytes: ret, encoding: NSUTF8StringEncoding)
            
            print(string)
            
        }catch{
            XCTAssert(false)
        }
    }
    
}
