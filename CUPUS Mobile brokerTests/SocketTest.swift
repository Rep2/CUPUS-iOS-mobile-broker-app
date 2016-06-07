//
//  CUPUS_Mobile_brokerTests.swift
//  CUPUS Mobile brokerTests
//
//  Created by Macbook Pro 1 on 25/04/2016.
//  Copyright © 2016 fer. All rights reserved.
//

import XCTest
@testable import CUPUS_Mobile_broker

class SocketTest: XCTestCase {
    
    func testUDPSocketCreate(){
        do{
            _ = try Socket.UDPSocket()
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }
    
    func testTCPSocketCreate(){
        do{
            _ = try TCPSocket()
            XCTAssert(true)
        }catch{
            XCTAssert(false)
        }
    }

}

