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
            let socket = try IRSocket.TCPSocket()
            
            socket.sendTo(IRSockaddr(port: 8889), string: "Message")
            
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    
}
