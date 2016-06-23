//
//  CUPUSTest.swift
//  CUPUS Mobile broker
//
//  Created by Ivan Rep on 6/22/16.
//  Copyright © 2016 fer. All rights reserved.
//

import Foundation


import XCTest
@testable import CUPUS_Mobile_broker

class CUPUSTest:XCTestCase {
    
    func testSubscribe(){
        do{
            let clientSocket = try TCPClientImplementation.Create(SocketAddress(port: 10000))
            
            let outString = "{\"eid\":\"aa596564-a3de-4645-964b-36581501cbeb\",\"id\":\"e1e5b1eb2d71f5da8c6600e3889349cf\",\"type\":\"SubscriberTcpRegisterMessage\",\"message\":\"{\"port\":0,\"ip\":\"10.201.17.170\",\"en\":\"Subscriber\",\"id\":\"aa596564-a3de-4645-964b-36581501cbeb\"}\",\"timestamp\":1465301410588}"
            
            let outLength = outString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            
            let sentCount = try clientSocket.send(outString)
            
            XCTAssert(outLength == sentCount)
            
        }catch{
            XCTAssert(false)
        }
    }
}